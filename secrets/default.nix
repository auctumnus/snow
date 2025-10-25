let
  autumn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIv+S9RTf4i7QstL62pQBllIyKh3P7ZYjySsYQkos+39";
  publicKeys = [ autumn ];
  secret = { inherit publicKeys; };
in
{
}
