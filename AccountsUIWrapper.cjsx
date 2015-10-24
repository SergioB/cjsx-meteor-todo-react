@AccountsUIWrapper = React.createClass
    componentDidMount: ->
        #user Meteor Blaze to render login buttons
        this.view = Blaze.render(Template.loginButtons, React.findDOMNode(this.refs.container))

    componentWillUnmount: ->
        Blaze.remove this.view

    render: ->
        #just render a placeholder container that will be filled in
        <span ref="container" />