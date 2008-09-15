/*
 * Please do not edit this file.
 * It was generated using rpcgen.
 */

#ifndef _DB_SERVER_H_RPCGEN
#define	_DB_SERVER_H_RPCGEN

#include <rpc/rpc.h>

struct __env_cachesize_msg {
	u_int dbenvcl_id;
	u_int gbytes;
	u_int bytes;
	u_int ncache;
};
typedef struct __env_cachesize_msg __env_cachesize_msg;

struct __env_cachesize_reply {
	int status;
};
typedef struct __env_cachesize_reply __env_cachesize_reply;

struct __env_close_msg {
	u_int dbenvcl_id;
	u_int flags;
};
typedef struct __env_close_msg __env_close_msg;

struct __env_close_reply {
	int status;
};
typedef struct __env_close_reply __env_close_reply;

struct __env_create_msg {
	u_int timeout;
};
typedef struct __env_create_msg __env_create_msg;

struct __env_create_reply {
	int status;
	u_int envcl_id;
};
typedef struct __env_create_reply __env_create_reply;

struct __env_flags_msg {
	u_int dbenvcl_id;
	u_int flags;
	u_int onoff;
};
typedef struct __env_flags_msg __env_flags_msg;

struct __env_flags_reply {
	int status;
};
typedef struct __env_flags_reply __env_flags_reply;

struct __env_open_msg {
	u_int dbenvcl_id;
	char *home;
	u_int flags;
	u_int mode;
};
typedef struct __env_open_msg __env_open_msg;

struct __env_open_reply {
	int status;
};
typedef struct __env_open_reply __env_open_reply;

struct __env_remove_msg {
	u_int dbenvcl_id;
	char *home;
	u_int flags;
};
typedef struct __env_remove_msg __env_remove_msg;

struct __env_remove_reply {
	int status;
};
typedef struct __env_remove_reply __env_remove_reply;

struct __txn_abort_msg {
	u_int txnpcl_id;
};
typedef struct __txn_abort_msg __txn_abort_msg;

struct __txn_abort_reply {
	int status;
};
typedef struct __txn_abort_reply __txn_abort_reply;

struct __txn_begin_msg {
	u_int dbenvcl_id;
	u_int parentcl_id;
	u_int flags;
};
typedef struct __txn_begin_msg __txn_begin_msg;

struct __txn_begin_reply {
	int status;
	u_int txnidcl_id;
};
typedef struct __txn_begin_reply __txn_begin_reply;

struct __txn_commit_msg {
	u_int txnpcl_id;
	u_int flags;
};
typedef struct __txn_commit_msg __txn_commit_msg;

struct __txn_commit_reply {
	int status;
};
typedef struct __txn_commit_reply __txn_commit_reply;

struct __txn_discard_msg {
	u_int txnpcl_id;
	u_int flags;
};
typedef struct __txn_discard_msg __txn_discard_msg;

struct __txn_discard_reply {
	int status;
};
typedef struct __txn_discard_reply __txn_discard_reply;

struct __txn_prepare_msg {
	u_int txnpcl_id;
	char gid[128];
};
typedef struct __txn_prepare_msg __txn_prepare_msg;

struct __txn_prepare_reply {
	int status;
};
typedef struct __txn_prepare_reply __txn_prepare_reply;

struct __txn_recover_msg {
	u_int dbenvcl_id;
	u_int count;
	u_int flags;
};
typedef struct __txn_recover_msg __txn_recover_msg;

struct __txn_recover_reply {
	int status;
	struct {
		u_int txn_len;
		u_int *txn_val;
	} txn;
	struct {
		u_int gid_len;
		char *gid_val;
	} gid;
	u_int retcount;
};
typedef struct __txn_recover_reply __txn_recover_reply;

struct __db_associate_msg {
	u_int dbpcl_id;
	u_int sdbpcl_id;
	u_int flags;
};
typedef struct __db_associate_msg __db_associate_msg;

struct __db_associate_reply {
	int status;
};
typedef struct __db_associate_reply __db_associate_reply;

struct __db_bt_maxkey_msg {
	u_int dbpcl_id;
	u_int maxkey;
};
typedef struct __db_bt_maxkey_msg __db_bt_maxkey_msg;

struct __db_bt_maxkey_reply {
	int status;
};
typedef struct __db_bt_maxkey_reply __db_bt_maxkey_reply;

struct __db_bt_minkey_msg {
	u_int dbpcl_id;
	u_int minkey;
};
typedef struct __db_bt_minkey_msg __db_bt_minkey_msg;

struct __db_bt_minkey_reply {
	int status;
};
typedef struct __db_bt_minkey_reply __db_bt_minkey_reply;

struct __db_close_msg {
	u_int dbpcl_id;
	u_int flags;
};
typedef struct __db_close_msg __db_close_msg;

struct __db_close_reply {
	int status;
};
typedef struct __db_close_reply __db_close_reply;

struct __db_create_msg {
	u_int dbenvcl_id;
	u_int flags;
};
typedef struct __db_create_msg __db_create_msg;

struct __db_create_reply {
	int status;
	u_int dbcl_id;
};
typedef struct __db_create_reply __db_create_reply;

struct __db_del_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int flags;
};
typedef struct __db_del_msg __db_del_msg;

struct __db_del_reply {
	int status;
};
typedef struct __db_del_reply __db_del_reply;

struct __db_extentsize_msg {
	u_int dbpcl_id;
	u_int extentsize;
};
typedef struct __db_extentsize_msg __db_extentsize_msg;

struct __db_extentsize_reply {
	int status;
};
typedef struct __db_extentsize_reply __db_extentsize_reply;

struct __db_flags_msg {
	u_int dbpcl_id;
	u_int flags;
};
typedef struct __db_flags_msg __db_flags_msg;

struct __db_flags_reply {
	int status;
};
typedef struct __db_flags_reply __db_flags_reply;

struct __db_get_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __db_get_msg __db_get_msg;

struct __db_get_reply {
	int status;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
};
typedef struct __db_get_reply __db_get_reply;

struct __db_h_ffactor_msg {
	u_int dbpcl_id;
	u_int ffactor;
};
typedef struct __db_h_ffactor_msg __db_h_ffactor_msg;

struct __db_h_ffactor_reply {
	int status;
};
typedef struct __db_h_ffactor_reply __db_h_ffactor_reply;

struct __db_h_nelem_msg {
	u_int dbpcl_id;
	u_int nelem;
};
typedef struct __db_h_nelem_msg __db_h_nelem_msg;

struct __db_h_nelem_reply {
	int status;
};
typedef struct __db_h_nelem_reply __db_h_nelem_reply;

struct __db_key_range_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int flags;
};
typedef struct __db_key_range_msg __db_key_range_msg;

struct __db_key_range_reply {
	int status;
	double less;
	double equal;
	double greater;
};
typedef struct __db_key_range_reply __db_key_range_reply;

struct __db_lorder_msg {
	u_int dbpcl_id;
	u_int lorder;
};
typedef struct __db_lorder_msg __db_lorder_msg;

struct __db_lorder_reply {
	int status;
};
typedef struct __db_lorder_reply __db_lorder_reply;

struct __db_open_msg {
	u_int dbpcl_id;
	char *name;
	char *subdb;
	u_int type;
	u_int flags;
	u_int mode;
};
typedef struct __db_open_msg __db_open_msg;

struct __db_open_reply {
	int status;
	u_int type;
	u_int dbflags;
	u_int lorder;
};
typedef struct __db_open_reply __db_open_reply;

struct __db_pagesize_msg {
	u_int dbpcl_id;
	u_int pagesize;
};
typedef struct __db_pagesize_msg __db_pagesize_msg;

struct __db_pagesize_reply {
	int status;
};
typedef struct __db_pagesize_reply __db_pagesize_reply;

struct __db_pget_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int skeydlen;
	u_int skeydoff;
	u_int skeyulen;
	u_int skeyflags;
	struct {
		u_int skeydata_len;
		char *skeydata_val;
	} skeydata;
	u_int pkeydlen;
	u_int pkeydoff;
	u_int pkeyulen;
	u_int pkeyflags;
	struct {
		u_int pkeydata_len;
		char *pkeydata_val;
	} pkeydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __db_pget_msg __db_pget_msg;

struct __db_pget_reply {
	int status;
	struct {
		u_int skeydata_len;
		char *skeydata_val;
	} skeydata;
	struct {
		u_int pkeydata_len;
		char *pkeydata_val;
	} pkeydata;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
};
typedef struct __db_pget_reply __db_pget_reply;

struct __db_put_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __db_put_msg __db_put_msg;

struct __db_put_reply {
	int status;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
};
typedef struct __db_put_reply __db_put_reply;

struct __db_re_delim_msg {
	u_int dbpcl_id;
	u_int delim;
};
typedef struct __db_re_delim_msg __db_re_delim_msg;

struct __db_re_delim_reply {
	int status;
};
typedef struct __db_re_delim_reply __db_re_delim_reply;

struct __db_re_len_msg {
	u_int dbpcl_id;
	u_int len;
};
typedef struct __db_re_len_msg __db_re_len_msg;

struct __db_re_len_reply {
	int status;
};
typedef struct __db_re_len_reply __db_re_len_reply;

struct __db_re_pad_msg {
	u_int dbpcl_id;
	u_int pad;
};
typedef struct __db_re_pad_msg __db_re_pad_msg;

struct __db_re_pad_reply {
	int status;
};
typedef struct __db_re_pad_reply __db_re_pad_reply;

struct __db_remove_msg {
	u_int dbpcl_id;
	char *name;
	char *subdb;
	u_int flags;
};
typedef struct __db_remove_msg __db_remove_msg;

struct __db_remove_reply {
	int status;
};
typedef struct __db_remove_reply __db_remove_reply;

struct __db_rename_msg {
	u_int dbpcl_id;
	char *name;
	char *subdb;
	char *newname;
	u_int flags;
};
typedef struct __db_rename_msg __db_rename_msg;

struct __db_rename_reply {
	int status;
};
typedef struct __db_rename_reply __db_rename_reply;

struct __db_stat_msg {
	u_int dbpcl_id;
	u_int flags;
};
typedef struct __db_stat_msg __db_stat_msg;

struct __db_stat_reply {
	int status;
	struct {
		u_int stats_len;
		u_int *stats_val;
	} stats;
};
typedef struct __db_stat_reply __db_stat_reply;

struct __db_sync_msg {
	u_int dbpcl_id;
	u_int flags;
};
typedef struct __db_sync_msg __db_sync_msg;

struct __db_sync_reply {
	int status;
};
typedef struct __db_sync_reply __db_sync_reply;

struct __db_truncate_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int flags;
};
typedef struct __db_truncate_msg __db_truncate_msg;

struct __db_truncate_reply {
	int status;
	u_int count;
};
typedef struct __db_truncate_reply __db_truncate_reply;

struct __db_cursor_msg {
	u_int dbpcl_id;
	u_int txnpcl_id;
	u_int flags;
};
typedef struct __db_cursor_msg __db_cursor_msg;

struct __db_cursor_reply {
	int status;
	u_int dbcidcl_id;
};
typedef struct __db_cursor_reply __db_cursor_reply;

struct __db_join_msg {
	u_int dbpcl_id;
	struct {
		u_int curs_len;
		u_int *curs_val;
	} curs;
	u_int flags;
};
typedef struct __db_join_msg __db_join_msg;

struct __db_join_reply {
	int status;
	u_int dbcidcl_id;
};
typedef struct __db_join_reply __db_join_reply;

struct __dbc_close_msg {
	u_int dbccl_id;
};
typedef struct __dbc_close_msg __dbc_close_msg;

struct __dbc_close_reply {
	int status;
};
typedef struct __dbc_close_reply __dbc_close_reply;

struct __dbc_count_msg {
	u_int dbccl_id;
	u_int flags;
};
typedef struct __dbc_count_msg __dbc_count_msg;

struct __dbc_count_reply {
	int status;
	u_int dupcount;
};
typedef struct __dbc_count_reply __dbc_count_reply;

struct __dbc_del_msg {
	u_int dbccl_id;
	u_int flags;
};
typedef struct __dbc_del_msg __dbc_del_msg;

struct __dbc_del_reply {
	int status;
};
typedef struct __dbc_del_reply __dbc_del_reply;

struct __dbc_dup_msg {
	u_int dbccl_id;
	u_int flags;
};
typedef struct __dbc_dup_msg __dbc_dup_msg;

struct __dbc_dup_reply {
	int status;
	u_int dbcidcl_id;
};
typedef struct __dbc_dup_reply __dbc_dup_reply;

struct __dbc_get_msg {
	u_int dbccl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __dbc_get_msg __dbc_get_msg;

struct __dbc_get_reply {
	int status;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
};
typedef struct __dbc_get_reply __dbc_get_reply;

struct __dbc_pget_msg {
	u_int dbccl_id;
	u_int skeydlen;
	u_int skeydoff;
	u_int skeyulen;
	u_int skeyflags;
	struct {
		u_int skeydata_len;
		char *skeydata_val;
	} skeydata;
	u_int pkeydlen;
	u_int pkeydoff;
	u_int pkeyulen;
	u_int pkeyflags;
	struct {
		u_int pkeydata_len;
		char *pkeydata_val;
	} pkeydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __dbc_pget_msg __dbc_pget_msg;

struct __dbc_pget_reply {
	int status;
	struct {
		u_int skeydata_len;
		char *skeydata_val;
	} skeydata;
	struct {
		u_int pkeydata_len;
		char *pkeydata_val;
	} pkeydata;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
};
typedef struct __dbc_pget_reply __dbc_pget_reply;

struct __dbc_put_msg {
	u_int dbccl_id;
	u_int keydlen;
	u_int keydoff;
	u_int keyulen;
	u_int keyflags;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
	u_int datadlen;
	u_int datadoff;
	u_int dataulen;
	u_int dataflags;
	struct {
		u_int datadata_len;
		char *datadata_val;
	} datadata;
	u_int flags;
};
typedef struct __dbc_put_msg __dbc_put_msg;

struct __dbc_put_reply {
	int status;
	struct {
		u_int keydata_len;
		char *keydata_val;
	} keydata;
};
typedef struct __dbc_put_reply __dbc_put_reply;

#define	__DB_env_cachesize ((unsigned long)(1))
extern  __env_cachesize_reply * __db_env_cachesize_3003();
#define	__DB_env_close ((unsigned long)(2))
extern  __env_close_reply * __db_env_close_3003();
#define	__DB_env_create ((unsigned long)(3))
extern  __env_create_reply * __db_env_create_3003();
#define	__DB_env_flags ((unsigned long)(4))
extern  __env_flags_reply * __db_env_flags_3003();
#define	__DB_env_open ((unsigned long)(5))
extern  __env_open_reply * __db_env_open_3003();
#define	__DB_env_remove ((unsigned long)(6))
extern  __env_remove_reply * __db_env_remove_3003();
#define	__DB_txn_abort ((unsigned long)(7))
extern  __txn_abort_reply * __db_txn_abort_3003();
#define	__DB_txn_begin ((unsigned long)(8))
extern  __txn_begin_reply * __db_txn_begin_3003();
#define	__DB_txn_commit ((unsigned long)(9))
extern  __txn_commit_reply * __db_txn_commit_3003();
#define	__DB_txn_discard ((unsigned long)(10))
extern  __txn_discard_reply * __db_txn_discard_3003();
#define	__DB_txn_prepare ((unsigned long)(11))
extern  __txn_prepare_reply * __db_txn_prepare_3003();
#define	__DB_txn_recover ((unsigned long)(12))
extern  __txn_recover_reply * __db_txn_recover_3003();
#define	__DB_db_associate ((unsigned long)(13))
extern  __db_associate_reply * __db_db_associate_3003();
#define	__DB_db_bt_maxkey ((unsigned long)(14))
extern  __db_bt_maxkey_reply * __db_db_bt_maxkey_3003();
#define	__DB_db_bt_minkey ((unsigned long)(15))
extern  __db_bt_minkey_reply * __db_db_bt_minkey_3003();
#define	__DB_db_close ((unsigned long)(16))
extern  __db_close_reply * __db_db_close_3003();
#define	__DB_db_create ((unsigned long)(17))
extern  __db_create_reply * __db_db_create_3003();
#define	__DB_db_del ((unsigned long)(18))
extern  __db_del_reply * __db_db_del_3003();
#define	__DB_db_extentsize ((unsigned long)(19))
extern  __db_extentsize_reply * __db_db_extentsize_3003();
#define	__DB_db_flags ((unsigned long)(20))
extern  __db_flags_reply * __db_db_flags_3003();
#define	__DB_db_get ((unsigned long)(21))
extern  __db_get_reply * __db_db_get_3003();
#define	__DB_db_h_ffactor ((unsigned long)(22))
extern  __db_h_ffactor_reply * __db_db_h_ffactor_3003();
#define	__DB_db_h_nelem ((unsigned long)(23))
extern  __db_h_nelem_reply * __db_db_h_nelem_3003();
#define	__DB_db_key_range ((unsigned long)(24))
extern  __db_key_range_reply * __db_db_key_range_3003();
#define	__DB_db_lorder ((unsigned long)(25))
extern  __db_lorder_reply * __db_db_lorder_3003();
#define	__DB_db_open ((unsigned long)(26))
extern  __db_open_reply * __db_db_open_3003();
#define	__DB_db_pagesize ((unsigned long)(27))
extern  __db_pagesize_reply * __db_db_pagesize_3003();
#define	__DB_db_pget ((unsigned long)(28))
extern  __db_pget_reply * __db_db_pget_3003();
#define	__DB_db_put ((unsigned long)(29))
extern  __db_put_reply * __db_db_put_3003();
#define	__DB_db_re_delim ((unsigned long)(30))
extern  __db_re_delim_reply * __db_db_re_delim_3003();
#define	__DB_db_re_len ((unsigned long)(31))
extern  __db_re_len_reply * __db_db_re_len_3003();
#define	__DB_db_re_pad ((unsigned long)(32))
extern  __db_re_pad_reply * __db_db_re_pad_3003();
#define	__DB_db_remove ((unsigned long)(33))
extern  __db_remove_reply * __db_db_remove_3003();
#define	__DB_db_rename ((unsigned long)(34))
extern  __db_rename_reply * __db_db_rename_3003();
#define	__DB_db_stat ((unsigned long)(35))
extern  __db_stat_reply * __db_db_stat_3003();
#define	__DB_db_sync ((unsigned long)(36))
extern  __db_sync_reply * __db_db_sync_3003();
#define	__DB_db_truncate ((unsigned long)(37))
extern  __db_truncate_reply * __db_db_truncate_3003();
#define	__DB_db_cursor ((unsigned long)(38))
extern  __db_cursor_reply * __db_db_cursor_3003();
#define	__DB_db_join ((unsigned long)(39))
extern  __db_join_reply * __db_db_join_3003();
#define	__DB_dbc_close ((unsigned long)(40))
extern  __dbc_close_reply * __db_dbc_close_3003();
#define	__DB_dbc_count ((unsigned long)(41))
extern  __dbc_count_reply * __db_dbc_count_3003();
#define	__DB_dbc_del ((unsigned long)(42))
extern  __dbc_del_reply * __db_dbc_del_3003();
#define	__DB_dbc_dup ((unsigned long)(43))
extern  __dbc_dup_reply * __db_dbc_dup_3003();
#define	__DB_dbc_get ((unsigned long)(44))
extern  __dbc_get_reply * __db_dbc_get_3003();
#define	__DB_dbc_pget ((unsigned long)(45))
extern  __dbc_pget_reply * __db_dbc_pget_3003();
#define	__DB_dbc_put ((unsigned long)(46))
extern  __dbc_put_reply * __db_dbc_put_3003();
extern int db_rpc_serverprog_3003_freeresult();

/* the xdr functions */
extern bool_t xdr___env_cachesize_msg();
extern bool_t xdr___env_cachesize_reply();
extern bool_t xdr___env_close_msg();
extern bool_t xdr___env_close_reply();
extern bool_t xdr___env_create_msg();
extern bool_t xdr___env_create_reply();
extern bool_t xdr___env_flags_msg();
extern bool_t xdr___env_flags_reply();
extern bool_t xdr___env_open_msg();
extern bool_t xdr___env_open_reply();
extern bool_t xdr___env_remove_msg();
extern bool_t xdr___env_remove_reply();
extern bool_t xdr___txn_abort_msg();
extern bool_t xdr___txn_abort_reply();
extern bool_t xdr___txn_begin_msg();
extern bool_t xdr___txn_begin_reply();
extern bool_t xdr___txn_commit_msg();
extern bool_t xdr___txn_commit_reply();
extern bool_t xdr___txn_discard_msg();
extern bool_t xdr___txn_discard_reply();
extern bool_t xdr___txn_prepare_msg();
extern bool_t xdr___txn_prepare_reply();
extern bool_t xdr___txn_recover_msg();
extern bool_t xdr___txn_recover_reply();
extern bool_t xdr___db_associate_msg();
extern bool_t xdr___db_associate_reply();
extern bool_t xdr___db_bt_maxkey_msg();
extern bool_t xdr___db_bt_maxkey_reply();
extern bool_t xdr___db_bt_minkey_msg();
extern bool_t xdr___db_bt_minkey_reply();
extern bool_t xdr___db_close_msg();
extern bool_t xdr___db_close_reply();
extern bool_t xdr___db_create_msg();
extern bool_t xdr___db_create_reply();
extern bool_t xdr___db_del_msg();
extern bool_t xdr___db_del_reply();
extern bool_t xdr___db_extentsize_msg();
extern bool_t xdr___db_extentsize_reply();
extern bool_t xdr___db_flags_msg();
extern bool_t xdr___db_flags_reply();
extern bool_t xdr___db_get_msg();
extern bool_t xdr___db_get_reply();
extern bool_t xdr___db_h_ffactor_msg();
extern bool_t xdr___db_h_ffactor_reply();
extern bool_t xdr___db_h_nelem_msg();
extern bool_t xdr___db_h_nelem_reply();
extern bool_t xdr___db_key_range_msg();
extern bool_t xdr___db_key_range_reply();
extern bool_t xdr___db_lorder_msg();
extern bool_t xdr___db_lorder_reply();
extern bool_t xdr___db_open_msg();
extern bool_t xdr___db_open_reply();
extern bool_t xdr___db_pagesize_msg();
extern bool_t xdr___db_pagesize_reply();
extern bool_t xdr___db_pget_msg();
extern bool_t xdr___db_pget_reply();
extern bool_t xdr___db_put_msg();
extern bool_t xdr___db_put_reply();
extern bool_t xdr___db_re_delim_msg();
extern bool_t xdr___db_re_delim_reply();
extern bool_t xdr___db_re_len_msg();
extern bool_t xdr___db_re_len_reply();
extern bool_t xdr___db_re_pad_msg();
extern bool_t xdr___db_re_pad_reply();
extern bool_t xdr___db_remove_msg();
extern bool_t xdr___db_remove_reply();
extern bool_t xdr___db_rename_msg();
extern bool_t xdr___db_rename_reply();
extern bool_t xdr___db_stat_msg();
extern bool_t xdr___db_stat_reply();
extern bool_t xdr___db_sync_msg();
extern bool_t xdr___db_sync_reply();
extern bool_t xdr___db_truncate_msg();
extern bool_t xdr___db_truncate_reply();
extern bool_t xdr___db_cursor_msg();
extern bool_t xdr___db_cursor_reply();
extern bool_t xdr___db_join_msg();
extern bool_t xdr___db_join_reply();
extern bool_t xdr___dbc_close_msg();
extern bool_t xdr___dbc_close_reply();
extern bool_t xdr___dbc_count_msg();
extern bool_t xdr___dbc_count_reply();
extern bool_t xdr___dbc_del_msg();
extern bool_t xdr___dbc_del_reply();
extern bool_t xdr___dbc_dup_msg();
extern bool_t xdr___dbc_dup_reply();
extern bool_t xdr___dbc_get_msg();
extern bool_t xdr___dbc_get_reply();
extern bool_t xdr___dbc_pget_msg();
extern bool_t xdr___dbc_pget_reply();
extern bool_t xdr___dbc_put_msg();
extern bool_t xdr___dbc_put_reply();

#endif /* !_DB_SERVER_H_RPCGEN */
