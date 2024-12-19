require 'rails_helper'

RSpec.describe Admin::AddCollaborator, type: :routine do
  before(:all) do
    DatabaseCleaner.start

    @user = FactoryBot.create :user
  end
  after(:all)  { DatabaseCleaner.clean }

  let(:args) { { publishables: @publishables, user: @user, collaborator_type: collaborator_type } }
  subject    { described_class.call **args }

  [ Exercise, VocabTerm ].each do |publishable_class|
    context publishable_class.name.pluralize do
      before(:all) do
        DatabaseCleaner.start

        publishables = 3.times.map { FactoryBot.create(publishable_class.name.underscore.to_sym) }
        FactoryBot.create :author, user: @user, publication: publishables.first.publication
        FactoryBot.create :copyright_holder, user: @user, publication: publishables.last.publication
        @publishables = publishable_class.where id: publishables.map(&:id)
      end
      after(:all)  { DatabaseCleaner.clean }

      context 'Author' do
        let(:collaborator_type) { 'Author' }

        it 'assigns the given user as an Author of the given publishables' do
          expect { subject }.to  change { Author.count }.by(2)
                            .and not_change { CopyrightHolder.count }

          @publishables.each do |publishable|
            expect(publishable.authors.map(&:user)).to include @user
          end
        end
      end

      context 'Copyright Holder' do
        let(:collaborator_type) { 'Copyright Holder' }

        it 'assigns the given user as a Copyright Holder of the given publishables' do
          expect { subject }.to  not_change { Author.count }
                            .and change { CopyrightHolder.count }.by(2)

          @publishables.each do |publishable|
            expect(publishable.copyright_holders.map(&:user)).to include @user
          end
        end
      end

      context 'Both' do
        let(:collaborator_type) { 'Both' }

        it 'assigns the given user as an Author and Copyright Holder of the given publishables' do
          expect { subject }.to  change { Author.count }.by(2)
                            .and change { CopyrightHolder.count }.by(2)

          @publishables.each do |publishable|
            expect(publishable.authors.map(&:user)).to include @user
            expect(publishable.copyright_holders.map(&:user)).to include @user
          end
        end
      end
    end
  end
end
