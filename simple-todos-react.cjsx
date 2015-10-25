@Tasks = new Mongo.Collection("tasks")

if Meteor.isClient

  Accounts.ui.config
    passwordSignupFields: "USERNAME_ONLY"

  Meteor.subscribe "tasks"

  Meteor.startup ->
    React.render(<App />, document.getElementById("render-target"))


if Meteor.isServer
  Meteor.publish "tasks", ->
    Tasks.find
      $or: [
        {private: {$ne: true}}
        {owner: @userId}
      ]

Meteor.methods
  addTask: (text) ->
    if ! Meteor.userId()
      throw new Meteor.Error "not-authorized"

    Tasks.insert
      text: text,
      createdAt: new Date()
      owner: Meteor.userId()
      username: Meteor.user().username

  removeTask: (taskId) ->
    task = Tasks.findOne(taskId)

    if task.private AND task.owner != Meteor.userId()
      throw new Meteor.Error "not-authorized"

    Tasks.remove taskId

  setChecked: (taskId, newCheckedStatus) ->
    task = Tasks.findOne(taskId)

    if task.private && task.owner != Meteor.userId()
      throw new Meteor.Error "not-authorized"

    Tasks.update(taskId, {$set: {checked: newCheckedStatus} })

  setPrivate: (taskId, setToPrivate) ->
    task = Tasks.findOne(taskId)

    #Make sure only task owner can make a task private
    if task.owner != Meteor.userId()
      throw new Meteor.Error "not-authorized"

    Tasks.update taskId, {$set: { private: setToPrivate} }
