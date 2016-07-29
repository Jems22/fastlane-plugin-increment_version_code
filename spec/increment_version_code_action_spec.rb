describe Fastlane::Actions::IncrementVersionCodeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The increment_version_code plugin is working!")

      Fastlane::Actions::IncrementVersionCodeAction.run(nil)
    end
  end
end
