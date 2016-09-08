#= require action_cable
#= require_self
#= require_tree ./channels

window.App =
  current_user_id: 1
  cable: ActionCable.createConsumer()

class Inboxes
  constructor: ->
    @initSendMessageButton()
    @initDeleteMessageButton()
    @initUserSendMessageButton()
    @initActionCable()

  initActionCable: ->
    console.log("ddddd")
    window.notificationChannel = App.cable.subscriptions.create "LettersChannel",
      connected: ->
        console.log("connnect...")
        setTimeout =>
            @subscribe()
            $(window).on 'unload', -> window.notificationChannel.unsubscribe()
            $(document).on 'page:change', -> window.notificationChannel.subscribe()
          , 1000
      received: (data) ->
        #@receivedNotificationCount(data)
        console.log("recived")
        console.log(data)

      subscribe: ->
        @perform 'subscribed'
        console.log("subscribed")

      unsubscribe: ->
        @perform 'unsubscribed'
        console.log("unsubscribed")

  initSendMessageButton: ->
    return if $(".inbox-send-button").length == 0
    that = this;
    $(".inbox-show-textarea").focus ->
      $(".inbox-error").html("")
      $(".inbox-notice").html("")

    $(".inbox-send-button").click -> 
      content = $(".inbox-show-textarea").val()
      if content.length == 0
        $(".inbox-error").html("亲, 内容不能为空!")
        return
      if content.length > 200
        $(".inbox-error").html("亲, 内容太长了!")
        return


      $.ajax
        url: '/messages'
        type: "POST"
        data: {username: $(this).attr("data-username"), content: content}
        dataType: "JSON"
        success: (e, status, res) ->
          console.log(res["status"])
          body = jQuery.parseJSON(res.responseText)
          if body.status
            $(".inbox-notice").html("发送成功!")
            $(".inbox-show-textarea").val('')
            that.appendMessageToHtml(body.message, body.is_self)
          else
            $(".inbox-error").html("发送失败: " + body.error)
        error: (res) ->
          $(".inbox-error").html("发送失败, 请稍候在试!" )

  appendMessageToHtml: (message, is_self) ->
    if is_self
      name = "我"
      deleteButton = "<span>
          <a class='inbox-message-delete'  data-message-id=" + message.id + " href='javascript:void(0);'' name='delete'>
            删除
          </a>
        </span>"
    else
      name = message.friend_name
      deleteButton = ""
    dom = "<div class='inbox-item inbox-item-" + message.id + "' >
      <div class='inbox-item-header'>
          " + name + ":
      </div>
      <div class='inbox-item-body'>
        <span>
            " + message.content  + "
        </span>
      </div>
      <div class='inbox-footer'>
        <span class='inbox-time inbox-left'>
          " + message.created_at + "
        </span>
        " + deleteButton + "
      </div>
    </div>"

    $(".message-list").prepend(dom)

  initDeleteMessageButton: ->
    $(".inbox-message-delete").click ->
      messageId = $(this).attr("data-message-id")
      $.ajax
        url: '/messages/' + messageId 
        type: "DELETE"
        dataType: "JSON"
        success: (e, status, res) ->
          console.log(res["status"])
          body = jQuery.parseJSON(res.responseText)
          if body.status
            window.location.reload()
          else
            $(".inbox-error").html("发送失败: " + body.error)
        error: (res) ->
          $(".inbox-error").html("发送失败, 请稍候在试!" )


  initUserSendMessageButton: ->
    $(".send-message").click -> 
      $(".modal-title").html("发送消息给" + $(this).attr("data-username"))
      $(".check-user-send-message-button").attr("data-username", $(this).attr("data-username"))
      
      $(".user-send-message-notice").html("")
      $(".user-send-message-error").html("")

      $(".user-send-message").modal('show')

    $(".message-body-input").focus ->
      $(".user-send-message-error").html("")
      $(".user-send-message-notice").html("")

    $(".check-user-send-message-button").click ->
      content = $(".message-body-input").val()
      if content.length == 0
        $(".user-send-message-error").html("亲, 内容不能为空!")
        return
      if content.length > 200
        $(".user-send-message-error").html("亲, 内容太长了!")
        return

      $.ajax
        url: '/messages'
        type: "POST"
        data: {username: $(this).attr("data-username"), content: content}
        dataType: "JSON"
        success: (e, status, res) ->
          console.log(res["status"])
          body = jQuery.parseJSON(res.responseText)
          if body.status
            $(".user-send-message-notice").html("发送成功!")
            $(".message-body-input").val("")
          else
            $(".user-send-message-error").html("发送失败: " + body.error)
        error: (res) ->
          $(".user-send-message-error").html("发送失败, 请稍候在试!" )

window._inboxHandler = new Inboxes()