function Coalesce-Args {
  (@($args | ?{$_}) + $null)[0]
}