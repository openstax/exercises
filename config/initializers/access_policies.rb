# Admin
OSU::AccessPolicy.register(Administrator, AdministratorAccessPolicy)
OSU::AccessPolicy.register(Format, FormatAccessPolicy)
OSU::AccessPolicy.register(License, LicenseAccessPolicy)

# User
OSU::AccessPolicy.register(Deputization, DeputizationAccessPolicy)
OSU::AccessPolicy.register(User, UserAccessPolicy)

# API
OSU::AccessPolicy.register(Derivation, DerivationAccessPolicy)
OSU::AccessPolicy.register(Exercise, ExerciseAccessPolicy)
OSU::AccessPolicy.register(Library, LibraryAccessPolicy)
OSU::AccessPolicy.register(List, ListAccessPolicy)
OSU::AccessPolicy.register(ListEditor, ListMemberAccessPolicy)
OSU::AccessPolicy.register(ListExercise, ListExerciseAccessPolicy)
OSU::AccessPolicy.register(ListOwner, ListMemberAccessPolicy)
OSU::AccessPolicy.register(ListReader, ListMemberAccessPolicy)
OSU::AccessPolicy.register(Publication, PublicationAccessPolicy)
OSU::AccessPolicy.register(Solution, SolutionAccessPolicy)
