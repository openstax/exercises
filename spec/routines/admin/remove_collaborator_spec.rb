require 'rails_helper'

RSpec.describe Admin::RemoveCollaborator, type: :routine do
  before(:all) do
    DatabaseCleaner.start

    @user = FactoryBot.create :user
  end
  after(:all)  { DatabaseCleaner.clean }

  let(:args) { { publishables: @pub_relation, user: @user, collaborator_type: collaborator_type } }
  subject    { described_class.call **args }

  [ Exercise, VocabTerm ].each do |publishable_class|
    context publishable_class.name.pluralize do
      before(:all) do
        DatabaseCleaner.start

        @publishables = 4.times.map { FactoryBot.create publishable_class.name.underscore.to_sym }
        FactoryBot.create :author, user: @user, publication: @publishables.first.publication
        FactoryBot.create :author, user: @user, publication: @publishables.second.publication
        FactoryBot.create :author, user: @user, publication: @publishables.last.publication
        FactoryBot.create :copyright_holder, user: @user,
                                             publication: @publishables.second.publication
        FactoryBot.create :copyright_holder, user: @user,
                                             publication: @publishables.third.publication
        FactoryBot.create :copyright_holder, user: @user,
                                             publication: @publishables.last.publication

        # Need some other collaborators to be able to remove the user
        @changed_publishables = @publishables[0..-2]
        @unchanged_publishable = @publishables[-1]
        @changed_publishables.each do |publishable|
          publication = publishable.publication.reload
          FactoryBot.create :author, publication: publication
          FactoryBot.create :copyright_holder, publication: publication
        end

        @pub_relation = publishable_class.where id: @publishables.map(&:id)
      end
      after(:all)  { DatabaseCleaner.clean }

      before { @publishables.each(&:reload) }

      context 'Author' do
        let(:collaborator_type) { 'Author' }

        it 'removes the given user as an Author of the given publishables' do
          expect { subject }.to  change { Author.count }.by(-2)
                            .and not_change { CopyrightHolder.count }

          @changed_publishables.each do |publishable|
            expect(publishable.authors.map(&:user)).not_to include @user
          end
          expect(@unchanged_publishable.authors.map(&:user)).to include @user
        end
      end

      context 'Copyright Holder' do
        let(:collaborator_type) { 'Copyright Holder' }

        it 'removes the given user as a Copyright Holder of the given publishables' do
          expect { subject }.to  not_change { Author.count }
                            .and change { CopyrightHolder.count }.by(-2)

          @changed_publishables.each do |publishable|
            expect(publishable.copyright_holders.map(&:user)).not_to include @user
          end
          expect(@unchanged_publishable.copyright_holders.map(&:user)).to include @user
        end
      end

      context 'Both' do
        let(:collaborator_type) { 'Both' }

        it 'removes the given user as an Author and Copyright Holder of the given publishables' do
          expect { subject }.to  change { Author.count }.by(-2)
                            .and change { CopyrightHolder.count }.by(-2)

          @changed_publishables.each do |publishable|
            expect(publishable.authors.map(&:user)).not_to include @user
            expect(publishable.copyright_holders.map(&:user)).not_to include @user
          end
          expect(@unchanged_publishable.authors.map(&:user)).to include @user
          expect(@unchanged_publishable.copyright_holders.map(&:user)).to include @user
        end
      end
    end
  end
end
