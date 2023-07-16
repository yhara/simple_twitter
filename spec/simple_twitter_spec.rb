RSpec.describe SimpleTwitter::Client do
  describe "get with API v2" do
    subject { client.get("https://api.twitter.com/2/tweets", params: { ids: "1460323737035677698,1519781379172495360,1519781381693353984" }) }

    let(:client) { SimpleTwitter::Client.new(bearer_token: "test_bearer_token") }

    before do
      stub_request(:get, "https://api.twitter.com/2/tweets?ids=1460323737035677698,1519781379172495360,1519781381693353984").
        with(
          headers: {
            'Authorization'=>'Bearer test_bearer_token',
          }).
        to_return(status: 200, body: fixture("get_tweets.json"))
    end

    it "get response" do
      tweets = subject[:data]

      expect(tweets.count).to eq 3
      expect(tweets[0][:id]).to eq "1460323737035677698"
      expect(tweets[0][:text]).to eq "Introducing a new era for the Twitter Developer Platform! nn📣The Twitter API v2 is now the primary API and full of new featuresn⏱Immediate access for most use cases, or apply to get more access for freen📖Removed certain restrictions in the Policynhttps://t.co/Hrm15bkBWJ https://t.co/YFfCDErHsg"
    end
  end
end
