require 'test_helper'

class MyRecordsControllerTest < ActionController::TestCase
  setup do
    @my_record = my_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:my_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create my_record" do
    assert_difference('MyRecord.count') do
      post :create, my_record: { name: @my_record.name }
    end

    assert_redirected_to my_record_path(assigns(:my_record))
  end

  test "should show my_record" do
    get :show, id: @my_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @my_record
    assert_response :success
  end

  test "should update my_record" do
    put :update, id: @my_record, my_record: { name: @my_record.name }
    assert_redirected_to my_record_path(assigns(:my_record))
  end

  test "should destroy my_record" do
    assert_difference('MyRecord.count', -1) do
      delete :destroy, id: @my_record
    end

    assert_redirected_to my_records_path
  end
end
