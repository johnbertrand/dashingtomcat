class Dashing.Tomcat extends Dashing.Widget

  @accessor 'currentready', ->
    threadready = @get('threadready')
    if threadready
      "Ready:" + threadready[threadready.length - 1].y

  @accessor 'currentservice', ->
    points = @get('threadservice')
    if points
      "Service: " + points[points.length - 1].y

  @accessor 'currentparse', ->
    points = @get('threadprepare')
    if points
      "Parse and prepare: " + points[points.length - 1].y

  @accessor 'currentfinishing', ->
    points = @get('threadfinishing')
    if points
      "Finishing: " + points[points.length - 1].y


  @accessor 'currentkeepalive', ->
    points = @get('threadkeepalive')
    if points
      "Keep Alive: " + points[points.length - 1].y


  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width  = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    palette = new Rickshaw.Color.Palette ( { scheme: 'colorwheel' } )

    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: "line"
      series: [
        {
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('threadready')     if @get('threadready')
    @graph.series[1].data = @get('threadservice')   if @get('threadservice')
    @graph.series[2].data = @get('threadprepare')   if @get('threadprepare')
    @graph.series[3].data = @get('threadfinishing') if @get('threadfinishing')
    @graph.series[4].data = @get('threadkeepalive') if @get('threadkeepalive')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.threadready
      @graph.series[1].data = data.threadservice
      @graph.series[2].data = data.threadprepare
      @graph.series[3].data = data.threadfinishing
      @graph.series[4].data = data.threadkeepalive
      @graph.render()
