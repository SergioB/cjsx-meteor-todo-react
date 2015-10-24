#Task component - represents a single todo item
@Task = React.createClass
    propTypes:
        #the component gets the task to display through a React group
        task: React.PropTypes.object.isRequired
        showPrivateButton: React.PropTypes.bool.isRequired

    toggleChecked: ->
        #Set the toggle property of the oposite of its current value
        Meteor.call "setChecked", @props.task._id, ! @props.task.checked

    deleteThisTask: ->
        Meteor.call "removeTask", @props.task._id

    togglePrivate: ->
        Meteor.call "setPrivate", @props.task._id, ! @props.task.private

    render: ->
        taskClassName = (if @props.task.checked then "checked" else "") + " "\
        + (if @props.task.private then "private" else "")

        <li className={taskClassName}>
            <button className="delete" onClick={this.deleteThisTask}>
                &times;
            </button>
            <input
                type="checkbox"
                readOnly={true}
                checked={this.props.task.checked}
                onClick={this.toggleChecked} />

            {if @props.showPrivateButton
                <button className="toggle-private" onClick={@togglePrivate} >
                    {if @props.task.private then "Private" else "Public"}
                </button>
            }

            <span className="text">
                <strong>{this.props.task.username}</strong> {this.props.task.text}
            </span>
        </li>
