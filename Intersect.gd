extends Spatial

var target = preload("res://Target.tscn")

func _ready():
	pass
	
func _physics_process(delta):
	
	if Input.is_action_pressed("ui_left"):
		self.global_rotate(self.global_transform.basis.y, 2.5 * delta)
	if Input.is_action_pressed("ui_right"):
		self.global_rotate(self.global_transform.basis.y, -2.5 * delta)
	if Input.is_action_pressed("ui_up"):
		self.global_rotate(self.global_transform.basis.x, -2.5 * delta)
	if Input.is_action_pressed("ui_down"):
		self.global_rotate(self.global_transform.basis.x, 2.5 * delta)
	
	is_intersecting(self.global_transform.origin, self.global_transform.basis.z * 800)

func is_intersecting(from:Vector3, to:Vector3) -> bool:
	var space = get_world().space
	var state = PhysicsServer.space_get_direct_state(space)
	var intersection = state.intersect_ray(from, to, [self])
	var result = Basis()
	
	if !intersection.empty():
		var isp = intersection.position
		var normal = intersection.normal
		
		var new_target = target.instance()
		get_tree().get_root().add_child(new_target)
		
		new_target.global_transform.origin = isp
		new_target.global_transform.basis = align_up(new_target.global_transform.basis, normal)
		
		return true
	
	return false
		

func align_up(node_basis, normal):
	var result = Basis()
	var scale = node_basis.get_scale() # Only if your node might have a scale other than (1,1,1)

	result.x = normal.cross(node_basis.z)
	result.y = normal
	result.z = node_basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 

	return result
