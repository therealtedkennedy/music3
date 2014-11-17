function s3_direct_upload(){
    $('.direct-upload').each(function() {

        ted_log("in_s3_direct_upload")

        var form = $(this),
            s3ObjectType,
            s3Id,
            image_save_location,
            imageType,
            s3_file_name,
            meta_url;

        ted_log("form= "+form)
        ted_log("this="+$(this))

        $(this).fileupload({
            url: form.attr('action'),
            type: 'POST',
            autoUpload: true,
            dataType: 'xml', // This is really important as s3 gives us back the url of the file in a XML document
            add: function (event, data) {

                //Image upload only - sets image type (logo, bk ground, song, album art ect)
                imageType = $(event.target).find('.s3_upload').attr('id');
                // sets object type for upload (image and song ect)
                s3ObjectType = $(event.target).find('.s3_upload').data("object_type");
                //Image only - url for saving the image on s3
                image_save_location = $(event.target).find('.s3_upload').data("object_image_save_url");
                //object name for s3
                s3Id = $(event.target).find('.s3_upload').data("object_id");
                //Defines the url for updating meta data in s3
                meta_url = $(event.target).find('.s3_upload').data("meta_url");


                ted_log("s3ObjectType= "+s3ObjectType);
                ted_log("s3id= "+ s3Id);
                ted_log("image type="+ imageType);
                ted_log("meta_url= "+ meta_url);


                // sets the s3 file name for image b/c need file name and ext
                if(s3ObjectType == "image")
                    var s3Name = s3Id+data.files[0].name;
                else
                    var s3Name = s3Id;
                ted_log("s3id= "+s3Id);

                $.ajax({
                    url: "/signed_urls"+"?object="+s3ObjectType,
                    type: 'GET',
                    dataType: 'json',
                    //								data: {doc: {title: data.files[0].name}}, // send the file name to the server so it can generate the key param

                    data: {doc: {title: s3Name}}, // send the file name to the server so it can generate the key param

                    async: false,
                    success: function(ajaxData) {
                        //for saving image and updating meta data
                        s3_file_name = (data.files[0].name);

                        // Now that we have our data, we update the form so it contains all
                        // the needed data to sign the request

                        form.find('input[name=key]').val(ajaxData.key);
                        form.find('input[name=policy]').val(ajaxData.policy);
                        form.find('input[name=signature]').val(ajaxData.signature);
                        //updates S3 Meta Information
                        form.find('input[name=x-amz-meta-my-file-name]').val(s3_file_name)

                        // for attachemts
                        if(s3ObjectType !="image"){
                            ted_log("in update meta for songs and other")
                            form.find('input[name=Content-Disposition]').val("attachment;filename=\"" + s3_file_name + "\"")
                            //updates name in form feild
                            ted_log("s3_file_name inside not image if statement= "+s3_file_name)
                            var file_name_ext_remv = s3_file_name.substring(0, s3_file_name.indexOf('.'));

                            save_s3_meta_name(file_name_ext_remv, meta_url)
                            $('input[name="song[song_name]"]').val(file_name_ext_remv)
                        };
                        
                        ted_log ('data from server')
                        ted_log (s3Id)
                        ted_log (ajaxData.key)
                        ted_log (ajaxData.policy)
                        ted_log (ajaxData.signature)
                        ted_log (ajaxData)
                    }
                })


                var file_status = file_size_check(s3ObjectType,data.files[0].size);
                // $('.progress').text(Math.ceil(data.progress().loaded/data.files[0].size * 100) + "%");
                ted_log("File status= "+file_status);

                if(file_status == true){
                    ted_log("data= "+ data)
                    data.submit();
                };
            },

            send: function(e, data) {
                $(this).find('.progressContainer').fadeIn();
                $(this).find('.percent').text('0%');
            },
            progress: function(e, data){
                // This is what makes everything really cool, thanks to that callback
                // you can now update the progress bar based on the upload progress
                var percent = Math.round((e.loaded / e.total) * 100)
                $(this).find('.bar').css('width', percent + '%')
                $(this).find('.percent').text(percent + '%');
            },
            fail: function(e, data) {
                ted_log('fail upload')
                ted_log(data)


            },
            success: function(data) {
                // Here we get the file url on s3 in an xml doc
                var url = $(data).find('Location').text()
                ted_log(url)
                ted_log(data)

                if (s3ObjectType == "image"){
                    ted_log("in save image file")
                    ted_log("image save location= "+image_save_location)
                    $.ajax({
                        url:image_save_location,
                        type: "post",
                        data: {
                            type: imageType,
                            file_name: s3_file_name
                        },
                        success:
                            function(){console.log("image updated")},

                        fail:
                            function(){ted_log("image save failed")}

                    })
                };
//						$( &#039;#real_file_url&#039; ).val(url) // Update the real input in the other form
            },
            done: function (event, data) {
                $(this).find('.progressContainer').fadeOut(300, function() {
                    $(this).find('.bar').css('width', 0)
                });
                $(this).find('.s3_upload').fadeOut();
                if(form.find('[name=file]').attr('id') === 'bk_image')
                    window.location.reload();
                else
                    showNotification(s3ObjectType + ' uploaded successfully.');
            }
        })
    })
}

function save_s3_meta_name (file_name_ext_remv,meta_update_url) {
    ted_log("in save s3 meta name, meta update url= "+ meta_update_url);
    $.ajax({
        url:meta_update_url,
        type: "post",
        data: {
            s3_meta_name: file_name_ext_remv
        },
        success:
            function(){console.log("saved")},

        fail:
            function(){ted_log("S3_meta_failed")}

    })
};

// client side validation of file size
function file_size_check(type,size){

    if(type == "image"){
        if (size > 1048576){
            alert("Image File exceeds 1 MB, please reduce the size and re upload")
            ted_log("File size is too large.  File is= "+size)

            return false
        } else {
            return true
        }
    } else {

        if (size > 104857600){
            alert("Song file exceeds 100MB, please reduce the size and re upload")
            ted_log("File size is too large.  File is= "+size)

            return false
        } else {
            return true
        }

    };


}