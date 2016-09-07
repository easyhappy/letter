class Inboxes
  constructor: ->
    @initSendMessageButton()
    @initDeleteMessageButton()

  initSendMessageButton: ->
    return if $(".inbox-send-button").length == 0
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
        data: {username: "kaka", content: content}
        dataType: "JSON"
        success: (e, status, res) ->
          console.log(res["status"])
          body = jQuery.parseJSON(res.responseText)
          if body.status
            $(".inbox-notice").html("发送成功!")
            $(".inbox-show-textarea").val('')
          else
            $(".inbox-error").html("发送失败: " + body.error)
        error: (res) ->
          $(".inbox-error").html("发送失败, 请稍候在试!" )

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


window._inboxHandler = new Inboxes()