require_relative 'doorkeeper'

Rails.application.config.after_initialize do
  # User
  OSU::AccessPolicy.register(User, UserAccessPolicy)
  OSU::AccessPolicy.register(Delegation, DelegationAccessPolicy)

  # API
  OSU::AccessPolicy.register(Exercise, ExerciseAccessPolicy)
  OSU::AccessPolicy.register(VocabTerm, VocabTermAccessPolicy)
  OSU::AccessPolicy.register(Attachment, AttachmentAccessPolicy)
  OSU::AccessPolicy.register(List, ListAccessPolicy)
  OSU::AccessPolicy.register(ListPublicationGroup, ListPublicationGroupAccessPolicy)
  OSU::AccessPolicy.register(Publication, PublicationAccessPolicy)
  OSU::AccessPolicy.register(CommunitySolution, CommunitySolutionAccessPolicy)
  OSU::AccessPolicy.register(OpenStax::Content::Book, BookAccessPolicy)

  # Doorkeeper
  OSU::AccessPolicy.register(Doorkeeper::Application, Doorkeeper::ApplicationAccessPolicy)
end
