from test_sqlite import *  # NOQA

DATABASES = {
    "default": {
        "ENGINE": "django.contrib.gis.db.backends.postgis",
        "USER": "user",
        "NAME": "geodjango",
        "PASSWORD": "postgres",
        "HOST": "localhost",
        "PORT": 5432,
    },
    "other": {
        "ENGINE": "django.contrib.gis.db.backends.postgis",
        "USER": "user",
        "NAME": "geodjango2",
        "PASSWORD": "postgres",
        "HOST": "localhost",
        "PORT": 5432,
    },
}
import faulthandler  # noqa
import multiprocessing  # noqa
import os  # noqa

_dump_dir = os.environ.get("HANG_DUMP_DIR")
# Only arm in spawned WORKERS, not the parent runtests process.
# Workers are spawned via multiprocessing; the parent's argv[0] is runtests.py.
_is_worker = multiprocessing.parent_process() is not None
if _dump_dir and _is_worker:
    _f = open(os.path.join(_dump_dir, f"hang_{os.getpid()}.txt"), "w", buffering=1)
    faulthandler.enable(file=_f)
    faulthandler.dump_traceback_later(300, repeat=False, exit=False, file=_f)
