class ExerciseEditor.Parts extends Backbone.Collection
  model: ExerciseEditor.Part

  # persisted: () ->
  #   filtered = this.filter (part) -> part.get("id")?
  #   new ExerciseEditor.Parts(filtered)
