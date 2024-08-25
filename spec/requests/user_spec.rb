require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #new" do
    before {get new_user_path}

    it 'レスポンスコードが200であること' do
      expect(response.status).to eq 200
    end
  end


  describe 'POST #create' do
    # やり方間違えているかも
    let(:referer) { users_path }

    context '正しいユーザ情報が渡って来た場合' do
      let(:params) do
        { user: {
          name: 'user',
          password: 'password',
          password_confirmation: 'password',
          }
        }
      end

      it 'ユーザーが一人増えていること' do
        expect {post users_path, params: params }.to change(User, :count).by(1)
      end

      it 'マイページにリダイレクトされること' do
        expect(post users_path, params: params).to redirect_to(mypage_path)
      end
    end

    context 'パラメータに正しいユーザ名、確認パスワードが含まれていない場合' do
      before do
        post(users_path, params: {
          user: {
            name: 'ユーザー1',
            password: 'password',
            password_confirmation: 'invalid_password'
          }
        }, headers: { 'HTTP_REFERER' => referer })
      end

      it 'リファラーにリダイレクトされること' do
        expect(response).to redirect_to(referer)
      end

      it 'ユーザ名のエラーメッセージが含まれていること' do
        expect(flash[:error_messages]).to include 'ユーザ名は小文字英数字で入力してください'
      end

      it 'パスワード確認のエラーメッセージが含まれていること' do
        expect(flash["error_messages"]).to include 'パスワード(確認)とパスワードの入力が一致しません'
      end
    end
  end
end
