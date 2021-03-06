#ifdef DOCS_INDEX
THIS(API)
#else
DOC(API, .)
#endif

#ifdef DOCS_TUTORIAL
THIS(Tutorial)
#else
DOC(Tutorial, libcurl-tutorial.html)
#endif

#ifdef DOCS_ERRORS
THIS(Error Codes)
#else
DOC(Error Codes, libcurl-errors.html)
#endif

#ifdef DOCS_SYMBOLS
THIS(Symbols In Versions)
#else
DOC(Symbols In Versions, symbols-in-versions.html)
#endif

#ifdef DOCS_ALLFUNCS
THIS(All Functions)
#else
DOC(All Functions, allfuncs.html)
#endif

#ifdef DOCS_OVERVIEW_EASY
THIS(easy Interface)
#else
DOC(easy Interface, libcurl-easy.html)
#endif

#ifdef DOCS_OVERVIEW_MULTI
THIS(multi Overview)
#else
DOC(multi Interface, libcurl-multi.html)
#endif

#ifdef DOCS_OVERVIEW_SHARE
THIS(share Interface)
#else
DOC(share Interface, libcurl-share.html)
#endif

#ifdef MENU_EASY
<hr>
#ifdef DOCS_EASY_ESCAPE
THIS(curl_easy_escape)
#else
DOC(curl_easy_escape, curl_easy_escape.html)
#endif

#ifdef DOCS_EASY_INIT
THIS(curl_easy_init)
#else
DOC(curl_easy_init, curl_easy_init.html)
#endif

#ifdef DOCS_EASY_CLEANUP
THIS(curl_easy_cleanup)
#else
DOC(curl_easy_cleanup, curl_easy_cleanup.html)
#endif

#ifdef DOCS_EASY_DUPHANDLE
THIS(curl_easy_duphandle)
#else
DOC(curl_easy_duphandle, curl_easy_duphandle.html)
#endif

#ifdef DOCS_EASY_GETINFO
THIS(curl_easy_getinfo)
#else
DOC(curl_easy_getinfo, curl_easy_getinfo.html)
#endif

#ifdef DOCS_EASY_PAUSE
THIS(curl_easy_pause)
#else
DOC(curl_easy_pause, curl_easy_pause.html)
#endif

#ifdef DOCS_EASY_PERFORM
THIS(curl_easy_perform)
#else
DOC(curl_easy_perform, curl_easy_perform.html)
#endif

#ifdef DOCS_EASY_RECV
THIS(curl_easy_recv)
#else
DOC(curl_easy_recv, curl_easy_recv.html)
#endif

#ifdef DOCS_EASY_RESET
THIS(curl_easy_reset)
#else
DOC(curl_easy_reset, curl_easy_reset.html)
#endif

#ifdef DOCS_EASY_SEND
THIS(curl_easy_send)
#else
DOC(curl_easy_send, curl_easy_send.html)
#endif

#ifdef DOCS_EASY_SETOPT
THIS(curl_easy_setopt)
#else
DOC(curl_easy_setopt, curl_easy_setopt.html)
#endif

#ifdef DOCS_EASY_STRERROR
THIS(curl_easy_strerror)
#else
DOC(curl_easy_strerror, curl_easy_strerror.html)
#endif

#ifdef DOCS_EASY_UNESCAPE
THIS(curl_easy_unescape)
#else
DOC(curl_easy_unescape, curl_easy_unescape.html)
#endif

#ifdef DOCS_ESCAPE
THIS(curl_escape)
#else
DOC(curl_escape, curl_escape.html)
#endif

#ifdef DOCS_FORMADD
THIS(curl_formadd)
#else
DOC(curl_formadd, curl_formadd.html)
#endif

#ifdef DOCS_FORMFREE
THIS(curl_formfree)
#else
DOC(curl_formfree, curl_formfree.html)
#endif

#ifdef DOCS_FREE
THIS(curl_free)
#else
DOC(curl_free, curl_free.html)
#endif

#ifdef DOCS_GETDATE
THIS(curl_getdate)
#else
DOC(curl_getdate, curl_getdate.html)
#endif

#if 0
#ifdef DOCS_GETENV
THIS(curl_getenv)
#else
DOC(curl_getenv, curl_getenv.html)
#endif
#endif

#ifdef DOCS_GLOBAL_CLEANUP
THIS(curl_global_cleanup)
#else
DOC(curl_global_cleanup, curl_global_cleanup.html)
#endif

#ifdef DOCS_GLOBAL_INIT
THIS(curl_global_init)
#else
DOC(curl_global_init, curl_global_init.html)
#endif

#ifdef DOCS_GLOBAL_INIT_MEM
THIS(curl_global_init_mem)
#else
DOC(curl_global_init_mem, curl_global_init_mem.html)
#endif

#if 0
#ifdef DOCS_MPRINTF
THIS(curl_mprintf)
#else
DOC(curl_mprintf, curl_mprintf.html)
#endif
#endif

#ifdef DOCS_SLIST_APPEND
THIS(curl_slist_append)
#else
DOC(curl_slist_append, curl_slist_append.html)
#endif

#ifdef DOCS_SLIST_FREE_ALL
THIS(curl_slist_free_all)
#else
DOC(curl_slist_free_all, curl_slist_free_all.html)
#endif

#if 0
#ifdef DOCS_STREQUAL
THIS(curl_strequal)
#else
DOC(curl_strequal, curl_strequal.html)
#endif
#endif

#ifdef DOCS_UNESCAPE
THIS(curl_unescape)
#else
DOC(curl_unescape, curl_unescape.html)
#endif

#ifdef DOCS_VERSION
THIS(curl_version)
#else
DOC(curl_version, curl_version.html)
#endif

#ifdef DOCS_VERSION_INFO
THIS(curl_version_info)
#else
DOC(curl_version_info, curl_version_info.html)
#endif

#endif /* MENU_EASY */

#ifdef MENU_MULTI
<hr>
#ifdef DOCS_MULTI_ADD_HANDLE
THIS(curl_multi_add_handle)
#else
DOC(curl_multi_add_handle, curl_multi_add_handle.html)
#endif

#ifdef DOCS_MULTI_ASSIGN
THIS(curl_multi_assign)
#else
DOC(curl_multi_assign, curl_multi_assign.html)
#endif

#ifdef DOCS_MULTI_CLEANUP
THIS(curl_multi_cleanup)
#else
DOC(curl_multi_cleanup, curl_multi_cleanup.html)
#endif

#ifdef DOCS_MULTI_FDSET
THIS(curl_multi_fdset)
#else
DOC(curl_multi_fdset, curl_multi_fdset.html)
#endif

#ifdef DOCS_MULTI_INFO_READ
THIS(curl_multi_info_read)
#else
DOC(curl_multi_info_read, curl_multi_info_read.html)
#endif

#ifdef DOCS_MULTI_INIT
THIS(curl_multi_init)
#else
DOC(curl_multi_init, curl_multi_init.html)
#endif

#ifdef DOCS_MULTI_PERFORM
THIS(curl_multi_perform)
#else
DOC(curl_multi_perform, curl_multi_perform.html)
#endif

#ifdef DOCS_MULTI_REMOVE_HANDLE
THIS(curl_multi_remove_handle)
#else
DOC(curl_multi_remove_handle, curl_multi_remove_handle.html)
#endif

#ifdef DOCS_MULTI_SETOPT
THIS(curl_multi_setopt)
#else
DOC(curl_multi_setopt, curl_multi_setopt.html)
#endif

#ifdef DOCS_MULTI_SOCKET
THIS(curl_multi_socket)
#else
DOC(curl_multi_socket, curl_multi_socket.html)
#endif

#ifdef DOCS_MULTI_SOCKET_ACTION
THIS(curl_multi_socket_action)
#else
DOC(curl_multi_socket_action, curl_multi_socket_action.html)
#endif

#ifdef DOCS_MULTI_STRERROR
THIS(curl_multi_strerror)
#else
DOC(curl_multi_strerror, curl_multi_strerror.html)
#endif

#ifdef DOCS_MULTI_TIMEOUT
THIS(curl_multi_timeout)
#else
DOC(curl_multi_timeout, curl_multi_timeout.html)
#endif

#ifdef DOCS_MULTI_WAIT
THIS(curl_multi_wait)
#else
DOC(curl_multi_wait, curl_multi_wait.html)
#endif

#endif /* MENU_MULTI */

#ifdef MENU_SHARE
<hr>
#ifdef DOCS_SHARE_CLEANUP
THIS(curl_share_cleanup)
#else
DOC(curl_share_cleanup, curl_share_cleanup.html)
#endif

#ifdef DOCS_SHARE_INIT
THIS(curl_share_init)
#else
DOC(curl_share_init, curl_share_init.html)
#endif

#ifdef DOCS_SHARE_SETOPT
THIS(curl_share_setopt)
#else
DOC(curl_share_setopt, curl_share_setopt.html)
#endif

#ifdef DOCS_SHARE_STRERROR
THIS(curl_share_strerror)
#else
DOC(curl_share_strerror, curl_share_strerror.html)
#endif


#endif /* MENU_SHARE */
