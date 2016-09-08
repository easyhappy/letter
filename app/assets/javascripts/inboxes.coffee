#= require action_cable
#= require_self
#= require_tree ./channels

window.App =
  cable: ActionCable.createConsumer()

class Inboxes
  constructor: ->
    @initSendMessageButton()
    @initDeleteMessageButton()
    @initUserSendMessageButton()
    @initActionCable()

  initActionCable: ->
    that = @
    window.notificationChannel = App.cable.subscriptions.create "LettersChannel",
      connected: ->
        setTimeout =>
            @subscribe()
            $(window).on 'unload', -> window.notificationChannel.unsubscribe()
            $(document).on 'page:change', -> window.notificationChannel.subscribe()
          , 1000
      received: (data) ->
        that.receivedNotificationData(data)
        console.log(data)

      subscribe: ->
        @perform 'subscribed'

      unsubscribe: ->
        @perform 'unsubscribed'

  receivedNotificationData: (data) ->
    if $(".current-page").length > 0 && $(".current-page").attr("data-current-page") == "inbox_list"
      @dealWithNotificationAtInboxListPage(data)
      return

    if $(".current-page").length > 0 && $(".current-page").attr("data-current-page") == "inbox_show"
      @dealWithNotificationAtInboxShowPage(data)
      return

    $(".inbox-center-navbar i.fa-comment").show()

  dealWithNotificationAtInboxListPage: (data) -> 
    itemClass = ".inbox-item-#{data.inbox.id}"
    console.log(itemClass)
    if $(itemClass).length > 0
      $("#{itemClass} .unread-count").html("#{data.inbox.unread_count}条未读")
      $("#{itemClass} .inbox-time").html(data.inbox.created_at)
      $("#{itemClass} .inbox-item-body span").html(data.message.content)
      unless $(".inbox-list").children().first().hasClass("inbox-item-#{data.inbox.id}")
        newItem = $(itemClass).clone()
        $(itemClass).remove()
        $(".inbox-list").prepend(newItem)
    else
      @addMessageToInboxListPage(data)

  addMessageToInboxListPage: (data) ->
    #### 此处需要优化
    html = "<div class='inbox-item inbox-item-#{data.inbox.id}' > \
              <div class='inbox-item-header'> \
                <a title='' class='pm-touser author-link' href=\"javascript:void(0)\"> \
                  #{ data.message.username } \
                </a>  \
                发送给我：\
             </div> \
            <div class=\"inbox-item-body\"> \
              <span> \
                #{data.message.content} \
              </span> \
            </div> \
            <div class=\"inbox-footer\"> \
              <span class=\"inbox-time inbox-left\"> \
                #{ data.inbox.created_at } \
              </span> \
              <span class=\"inbox-bull unread-count unread-count-#{data.inbox.id}\"> \
                #{data.inbox.unread_count}条未读 \
              </span> \
              <span class=\"inbox-bull\"> \
                | \
              </span> \
              <a class=\"inbox-show-detail\" href=\"/inboxes/#{data.inbox.id}\">查看详情</a> \
              <span class=\"inbox-bull\"> \
                | \
              </span> \
              <a data-confirm=\"确认删除吗?\" rel=\"nofollow\" data-method=\"delete\" href=\"/inboxes/#{data.inbox.id}\">删除</a> \
            </div> \
          </div>"

    $(".inbox-list").prepend(html)

  dealWithNotificationAtInboxShowPage: (data) ->
    console.log("走到这里了dfsadfasdf")
    console.log(parseInt($(".inbox-show-list").attr("data-inbox-id")))
    console.log(data.inbox.id)
    if parseInt($(".inbox-show-list").attr("data-inbox-id")) == data.inbox.id
      console.log("走到这里了")
      @appendMessageToHtml(data.message, false)

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
    if $(".inbox-item-#{message.id}").length > 0
      return
    if is_self
      name = "我"
      deleteButton = "<span>
                        <a class='inbox-message-delete'  data-message-id=#{message.id} href='javascript:void(0);'' name='delete'>
                          删除
                        </a>
                      </span>
                      "
    else
      name = message.friend_username
      deleteButton = ""

    dom = "<div class='inbox-item inbox-item-#{message.id}'>
            <div class='inbox-item-header'>
                #{name}:
            </div>
            <div class='inbox-item-body'>
              <span>
                  #{message.content}
              </span>
            </div>
            <div class='inbox-footer'>
              <span class='inbox-time inbox-left'>
                #{message.created_at}
              </span>
              #{deleteButton}
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