class ExerciseEditor.LogicOutputs extends Backbone.Collection
  model: ExerciseEditor.LogicOutput
  url: '/api/logics'

  # bulkCreate: (models, options={}) ->

  #   if @models.length == 0 then return

  #   _.defaults(
  #     options, 
  #     {
  #       url: @models[0].urlRoot + '/sort', 
  #       attrs: 
  #         newPositions: @collect (model) => {id: model.get('id'), position: model.get(@positionField)}
  #     }
  #   )

  #   @sync 'update', this, options

  # enMasse: (models, action='create', options={}) ->
    

  # save: () ->
  #   debugger
  #   console.log 'in logic outputs save'