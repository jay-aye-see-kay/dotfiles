let s:is_root_instance = 0

function IsRootInstanceRpcTest() abort
  let s:is_root_instance = 1
endfunction

if !empty($NVIM_LISTEN_ADDRESS)
  let conn_id = sockconnect('pipe', $NVIM_LISTEN_ADDRESS, {'rpc': 1})

  " send command to NVIM_LISTEN_ADDRESS to see if we're in the root instance
  call rpcrequest(conn_id, 'nvim_command', 'call IsRootInstanceRpcTest()')

  if !empty(bufname()) && !s:is_root_instance
    call rpcrequest(conn_id, 'nvim_command', 'edit ' . bufname())
    quit
  endif
endif
