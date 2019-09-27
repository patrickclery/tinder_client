RSpec.shared_context "default" do
  include WebMock::API
  subject { described_class }

  let!(:client) { Tinder::Client }
  let(:id) { "1a234a56123ab12345123456" }
  let(:api_token) { "12a3bc45-a123-123a-1a23-1234abc4de5f" }
  let(:refresh_token) { "xxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" }
  let(:confirmation_code) { "123456" }
  let(:phone_number) { "1234567890" }
end
