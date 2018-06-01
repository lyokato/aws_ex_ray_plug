Application.ensure_all_started(:mox)
Application.ensure_all_started(:aws_ex_ray)

AwsExRay.Client.Sandbox.start_link([])

ExUnit.start()
