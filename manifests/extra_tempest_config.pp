#
# Define tempest::extra_tempest_config
#
# This is just a wrapper on top of tempest_config so that one can use it with
# create_resources to create bulk configurations and can provide a hash of
# configurations through class param or through hiera.
#

define tempest::extra_tempest_config (
  $value,
  $config = $name,
  $set_id = undef,
) {
   tempest_config {$config:
    value  => $value,
    set_id => $set_id,
   }
}
