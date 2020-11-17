plan networking_examples::f5::node::status(
  TargetSpec    $targets,
  TargetSpec    $device,
  String        $node = '',
) {

  $username = get_target($device).config['ssh']['user']
  $password = get_target($device).config['ssh']['password']
  $ipaddress = get_target($device).uri

  $token = run_task('http_request', $targets, {
    'base_url'      => "https://${ipaddress}:8443/mgmt/shared/authn/login",
    'method'        => 'post',
    'json_endpoint' => true,
    'body'          => {
      'username'          => $username,
      'password'          => $password,
      'loginProviderName' => 'tmos'
    }
  } ).first.value['body']['token']['token']

  
  $status = run_task('http_request', $targets, {
    base_url      => "https://${ipaddress}:8443/mgmt/tm/ltm/node/${node}",
    json_endpoint => true,
    headers       => { 'X-F5-Auth-Token' => $token },
  } ).first.value['body']['state']

  return $status
}