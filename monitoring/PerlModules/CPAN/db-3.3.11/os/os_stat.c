/*-
 * See the file LICENSE for redistribution information.
 *
 * Copyright (c) 1997-2001
 *	Sleepycat Software.  All rights reserved.
 */

#include "db_config.h"

#ifndef lint
static const char revid[] = "$Id: os_stat.c,v 1.1.1.1 2002-01-11 00:21:37 apingel Exp $";
#endif /* not lint */

#ifndef NO_SYSTEM_INCLUDES
#include <sys/types.h>
#include <sys/stat.h>

#include <string.h>
#endif

#include "db_int.h"
#include "os_jump.h"

/*
 * __os_exists --
 *	Return if the file exists.
 *
 * PUBLIC: int __os_exists __P((const char *, int *));
 */
int
__os_exists(path, isdirp)
	const char *path;
	int *isdirp;
{
	struct stat sb;

	if (__db_jump.j_exists != NULL)
		return (__db_jump.j_exists(path, isdirp));

#ifdef HAVE_VXWORKS
	if (stat((char *)path, &sb) != 0)
#else
	if (stat(path, &sb) != 0)
#endif
		return (__os_get_errno());

#if !defined(S_ISDIR) || defined(STAT_MACROS_BROKEN)
#undef	S_ISDIR
#ifdef _S_IFDIR
#define	S_ISDIR(m)	(_S_IFDIR & (m))
#else
#define	S_ISDIR(m)	(((m) & 0170000) == 0040000)
#endif
#endif
	if (isdirp != NULL)
		*isdirp = S_ISDIR(sb.st_mode);

	return (0);
}

/*
 * __os_ioinfo --
 *	Return file size and I/O size; abstracted to make it easier
 *	to replace.
 *
 * PUBLIC: int __os_ioinfo __P((DB_ENV *, const char *,
 * PUBLIC:    DB_FH *, u_int32_t *, u_int32_t *, u_int32_t *));
 */
int
__os_ioinfo(dbenv, path, fhp, mbytesp, bytesp, iosizep)
	DB_ENV *dbenv;
	const char *path;
	DB_FH *fhp;
	u_int32_t *mbytesp, *bytesp, *iosizep;
{
	int ret;
#ifdef HAVE__FSTATI64
	struct _stati64 sb;
#else
	struct stat sb;
#endif

	if (__db_jump.j_ioinfo != NULL)
		return (__db_jump.j_ioinfo(path,
		    fhp->fd, mbytesp, bytesp, iosizep));

#ifdef HAVE__FSTATI64
	if (_fstati64(fhp->fd, &sb) == -1) {
#else
	if (fstat(fhp->fd, &sb) == -1) {
#endif
		ret = __os_get_errno();
		__db_err(dbenv, "fstat: %s", strerror(ret));
		return (ret);
	}

	/* Return the size of the file. */
	if (mbytesp != NULL)
		*mbytesp = (u_int32_t)(sb.st_size / MEGABYTE);
	if (bytesp != NULL)
		*bytesp = (u_int32_t)(sb.st_size % MEGABYTE);

	/*
	 * Return the underlying filesystem blocksize, if available.
	 *
	 * XXX
	 * Check for a 0 size -- the HP MPE/iX architecture has st_blksize,
	 * but it's always 0.
	 */
#ifdef HAVE_STRUCT_STAT_ST_BLKSIZE
	if (iosizep != NULL && (*iosizep = sb.st_blksize) == 0)
		*iosizep = DB_DEF_IOSIZE;
#else
	if (iosizep != NULL)
		*iosizep = DB_DEF_IOSIZE;
#endif
	return (0);
}
