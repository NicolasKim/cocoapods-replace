require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::Replace do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ replace }).should.be.instance_of Command::Replace
      end
    end
  end
end

