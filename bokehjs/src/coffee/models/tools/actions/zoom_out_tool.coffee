ActionTool = require "./action_tool"
{scale_range} = require "../../../util/zoom"
{logger} = require "../../../core/logging"

p = require "../../../core/properties"

class ZoomOutToolView extends ActionTool.View

  do: () ->
    frame = @plot_model.frame
    dims = @model.dimensions

    # restrict to axis configured in tool's dimensions property
    h_axis = 'width' in dims
    v_axis = 'height' in dims

    # zooming out requires a negative factor to scale_range
    zoom_info = scale_range(frame, -@model.factor, h_axis=h_axis, v_axis=v_axis)

    @plot_view.push_state('zoom_out', {range: zoom_info})
    @plot_view.update_range(zoom_info, false, true)
    @plot_view.interactive_timestamp = Date.now()
    return null

class ZoomOutTool extends ActionTool.Model
  default_view: ZoomOutToolView
  type: "ZoomOutTool"
  tool_name: "Zoom Out"
  icon: "bk-tool-icon-zoom-out"

  @getters {
    tooltip: () -> @_get_dim_tooltip(@tool_name, @_check_dims(@dimensions, "zoom-out tool"))
  }

  @define {
    factor: [ p.Percent, 0.1 ]
    dimensions: [ p.Array, ["width", "height"] ]
  }

module.exports = {
  Model: ZoomOutTool
  View: ZoomOutToolView
}
