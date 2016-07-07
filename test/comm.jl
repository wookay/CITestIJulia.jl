using Base.Test
import IJulia: Comm, comm_target

profile = normpath(dirname(@__FILE__), "profile.json")
IJulia.init([profile])
redirect_stdout(IJulia.orig_STDOUT)
redirect_stderr(IJulia.orig_STDERR)

target = :notarget
comm_id = "6BA197D8A67A455196279A59EB2FE844"
comm = Comm(target, comm_id)
@test :notarget == comm_target(comm)
@test comm.primary

close(IJulia.ctx)
