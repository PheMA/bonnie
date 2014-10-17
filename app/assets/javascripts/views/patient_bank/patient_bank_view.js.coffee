class Thorax.Views.PatientBankView extends Thorax.Views.BonnieView
  template: JST['patient_bank/patient_bank']
  events:
    'click .patient-filter-button': 'adjustDropdown'

    collection:
      sync: ->
        @differences.reset @collection.map (patient) => @currentPopulation.differenceFromExpected(patient)
    rendered: ->
      # TODO do we also need to @trigger 'rationale:clear' and set toggledPatient?
      @$('#sharedResults').on 'show.bs.collapse hidden.bs.collapse', (e) ->
        $(e.target).parent('.panel').find('.panel-chevron').toggleClass 'fa-angle-right fa-angle-down'

      @$('select.filter').selectBoxIt showFirstOption: false, autoWidth: false, theme:
        arrow: "patient-filter-arrow"
        button: "patient-filter-button"
        list: "patient-filter-list"
        container: "patient-filter-container"

  initialize: ->
    @collection = new Thorax.Collections.Patients
    @currentPopulation = @model.get('populations').first()
    @differences = new Thorax.Collections.Differences()


  differenceContext: (difference) ->
    _(difference.toJSON()).extend
      patient: difference.result.patient.toJSON()
      measure_id: @model.get('hqmf_set_id')
      episode_of_care: @model.get('episode_of_care')

  adjustDropdown: ->
    listWidth = @$('.patient-filter-container').width() - @$('.selectboxit-arrow-container').width()
    @$('.patient-filter-list').attr "style", (i,s) -> s + "min-width: #{listWidth}px !important;"

