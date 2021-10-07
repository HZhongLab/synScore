function h_setModifiedDate(filename, modifiedDate)

import java.io.File java.text.SimpleDateFormat
f = File(filename);
modifiedDate = datestr(modifiedDate, 'dd-mmm-yyyy HH:MM:SS PM');
sdf = SimpleDateFormat('dd-MMM-yyyy hh:mm:ss');
newDate = sdf.parse(modifiedDate);
f.setLastModified(newDate.getTime);