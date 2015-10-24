@App = React.createClass

    mixins: [ReactMeteorData],

    getInitialState: ->
        hideCompleted: false

    getMeteorData: ->
        query = if this.state.hideCompleted
            {checked: {$ne: true}}
        else
            {}

        #return
        tasks: Tasks.find(query, {sort: {createdAt: -1}}).fetch()
        incompleteCount: Tasks.find({checked: {$ne: true}}).count()
        currentUser: Meteor.user()

    renderTasks: ->
        currentUserId = @data.currentUser?._id
        @data.tasks.map (task) ->

            showPrivateButton = task.owner == currentUserId

            <Task
                key={task._id}
                task={task}
                showPrivateButton={showPrivateButton}/>

    handleSubmit: (event) ->
        event.preventDefault()
        text = React.findDOMNode(this.refs.textInput).value.trim()

        Meteor.call "addTask", text

        #Clear form
        React.findDOMNode(this.refs.textInput).value = ""

    toggleHideCompleted: ->
        this.setState
            hideCompleted: !this.state.hideCompleted

    render: ->
        <div classNme="container">
            <header>
                <h1>Todo List ({this.data.incompleteCount})</h1>

                <label className="hide-completed">
                    <input
                        type="checkbox"
                        readOnly={true}
                        checked={this.state.hideCompleted}
                        onClick={this.toggleHideCompleted} />
                    Hide Completed Tasks
                </label>

                <AccountsUIWrapper />

                {if @data.currentUser
                        <form className="new-task" onSubmit={this.handleSubmit} >
                            <input
                                type="text"
                                ref="textInput"
                                placeholder="Type to add a new task" />
                        </form>
                else <b>log in to add new tasks</b>}
            </header>
            <ul>
                  {this.renderTasks()}
            </ul>
        </div>