# This model exists solely to easily retrieve digests of library versions

class ExerciseEditor.LibraryVersionDigest extends Backbone.Model
  url: () -> '/api/library_versions/digest?ids=' + @get('ids').join(',')

  defaults:
    code: ''
    ids: []