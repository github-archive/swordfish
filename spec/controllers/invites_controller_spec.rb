require 'spec_helper'

describe InvitesController do
  let(:team) { double(:team, :id => next_id).as_null_object }
  let(:email) { 'bkeepers@github.com' }

  before do
    Team.stub! :find => team
  end

  context 'when signed in' do
    before { sign_in_as mock_user }

    describe 'create' do
      let(:invite) { double(:invite).as_null_object }

      before do
        team.stub! :invite => invite
        TeamMailer.stub!(:invite => double(:mailer).as_null_object)
      end

      subject do
        post :create,
          :team_id => team.id.to_s,
          :email => email
      end

      it { expect(subject.status).to be(201) }

      it 'creates an invite' do
        team.should_receive(:invite).with(email).and_return(invite)
        subject
      end

      it 'delivers an email' do
        TeamMailer.should_receive(:invite).with(team, invite)
        subject
      end
    end

    describe 'accept' do
      let(:invite) { double(:invite, :token => 'token', :accept => nil) }

      before do
        Invite.stub! :from_token => invite
      end

      subject do
        get :accept, :token => invite.token
      end

      it { expect(subject.status).to be(200) }

      it 'accepts the invite' do
        invite.should_receive(:accept).with(current_user)
        subject
      end
    end

    describe 'fulfill' do
      let(:invite) { double(:invite, :id => 42, :fulfill => nil) }
      let(:key) { 'key' }

      before do
        team.invites.stub! :find => invite
      end

      subject do
        post :fulfill, :team_id => team.id, :id => invite.id, :key => key
      end

      its(:status) { should be(200) }

      it 'fulfills the invite' do
        invite.should_receive(:fulfill).with(key)
        subject
      end
    end
  end

  context 'when signed out' do
    it { expect(post(:create, :team_id => 1, :format => :json).status).to be(401) }
  end
end
