plan network_examples::f5::ssl::upload_and_configure(
  TargetSpec $targets,
  TargetSpec $proxy,
  String[1]  $cert_name
) {

  upload_file("network_examples/${cert_name}.crt", "/var/tmp/${cert_name}.crt", $targets)
  upload_file("network_examples/${cert_name}.key", "/var/tmp/${cert_name}.key", $targets)

  $pp_template = @(PP)
    f5_sslcertificate { "/Common/<%= $cert_name %>":
      description      => "Certificate for <%= $cert_name %> deployed via Bolt",
      certificate_name => <%= $cert_name %>,
      from_local_file  => "/var/tmp/<%= $cert_name %>.crt",
    }
    f5_sslkey { "/Common/<%= $cert_name %>":
      description     => "Certificate key for <%= $cert_name %> deployed via Bolt",
      keyname         => <%= $cert_name %>,
      from_local_file => "/var/tmp/<%= $cert_name %>.key",
    }
    |PP

  $manifest = inline_epp($pp_template)

  autope::with_tempfile_containing('', $manifest, '.pp') |$pp_file| {
    upload_file($pp_file, $pp_file, get_target($proxy))

    run_command(
      "/opt/puppetlabs/bin/puppet device --apply ${pp_file} --verbose --target ${targets}",
      get_target($proxy),
    )

    run_command("rm ${pp_file}", get_target($proxy))
  }

  run_command("rm /var/tmp/${cert_name}.crt", $targets)
  run_command("rm /var/tmp/${cert_name}.key", $targets)
}
