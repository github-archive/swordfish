require 'spec_helper'

describe ItemsController do
  context 'when signed in' do
    before { sign_in_as mock_user }

    describe 'create' do
      subject do
        post :create,
          :title => 'example.com',
          :data  => 'encrypted',
          :key   => 'userkey'
      end

      it { expect(subject.status).to be(201) }

      it 'creates an item' do
        subject
        expect(Item.where(:title => 'example.com' ).first).to be_instance_of(Item)
      end
    end

    describe 'index' do
      subject do
        get :index
      end

      it { expect(subject.status).to be(200) }
    end

    describe 'update' do
      let(:item) { stub_model(Item, :id => next_id) }

      before do
        Item.stub! :find => item
      end

      subject do
        put :update, :id => item.id.to_s, :title => 'Updated'
      end

      context 'when user has access' do
        before do
          item.stub! :share_for => double(:share).as_null_object
        end

        it { expect(subject.status).to be(200) }

        it 'updates item' do
          item.should_receive :update_attributes
          subject
        end
      end

      context 'when user does not have access' do
        it { expect { subject.status }.to raise_error(ActiveRecord::RecordNotFound) }
      end
    end
  end

  context 'when signed out' do
    it { expect(post(:create, :format => :json).status).to be(401) }
  end
end
