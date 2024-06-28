extends Control
## Ping to internet
## Ensure connected to internet regardless of network connection

const API_URL = "https://gstatic.com/generate_204"

@export var ping_delay: int = 10

var HTTP: HTTPRequest


func _ready():
	# Create HTTP request node
	HTTP = HTTPRequest.new()
	HTTP.set_timeout(10)
	add_child(HTTP)
	HTTP.request_completed.connect(_on_request_completed)

	visible = false
	ping()


func ping():
	var request = HTTP.request(API_URL)
	if not request == OK:
		printerr("An error occurred in the ping HTTP request.")


func _on_request_completed(result, _response_code, _headers, _body):
	visible = false
	if not result == HTTPRequest.RESULT_SUCCESS:
		visible = true
		printerr("Not connected to internet.")

	await get_tree().create_timer(ping_delay).timeout
	ping()
