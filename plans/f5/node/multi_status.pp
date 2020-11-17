plan network_examples::f5::node::multi_status(
  TargetSpec    $targets,
  TargetSpec    $device,
  Array         $nodes_list = [],
  String        $username,
  String        $password,
  String        $ipaddress,
) {

  $status = Hash($nodes_list.map |$node| { [ $node,  
    run_plan('network_examples::f5::node::status', $targets, {
      'node' => $node,
      'device' => $device,
      'username' => $username,
      'password' => $password,
      'ipaddress' => $ipaddress,
    }) ]
  }.sort)

  return $status
}