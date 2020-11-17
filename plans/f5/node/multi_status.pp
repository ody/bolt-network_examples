plan networking_examples::f5::node::multi_status(
  TargetSpec    $targets,
  TargetSpec    $device,
  Array         $nodes_list = [],
) {

  $status = Hash($nodes_list.map |$node| { [ $node,  
    run_plan('networking_examples::f5::node::status', $targets, {
      'node' => $node,
      'device' => $device,
    }) ]
  }.sort)

  return $status
}