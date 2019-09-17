* Supreme AWS Utility Vehicle

This script currently serves two purposes:

-Associate an elastic IP address with an EC2 instance (by instance id):
  ruby util.rb --action=assign_ip --hosts=x.x.x.x --instance_id=i-1337b457ard
  
-Swap two instances' elastic IP associations (by hostname or IP address):
  ruby util.rb --action=swap --hosts=openvault.wgbh.org,x.x.x.x

  OR

  ruby util.rb --action=swap --hosts=demo.aapb.wgbh-mla.org,americanarchive.org
  
  OR

  ruby util.rb --action=swap --hosts=demo.aapb.wgbh-mla.org,https://americanarchive.org

For a bit of additional usage info, try:
  ruby util.rb --help