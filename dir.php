<?php

$dir = $_SERVER['REQUEST_URI'];
$dir_request = $dir;
#print "\$dir_request: $dir_request\n";
$dir_is_year = 0;
if (preg_match('/^\/\d+\/$/', $dir)) {
  // "/2015/", etc.
  $dir_is_year = 1;
  $dir = preg_replace('/\/(\d+)\/$/', '${1}', $dir);
} else {
  // Not a year directory".
  $dir = preg_replace('/^.*\/(\w+)\/$/', '${1}', $dir);
}

?>
<!DOCTYPE html>
<html lang="en-US">
<head>
  <meta charset="utf-8">
  <title><?php print "$dir" ?></title>
  <link rel="stylesheet" type="text/css" href="/style.css" />
</head>
<body>

<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
ga('create', 'UA-109975-1', 'auto');
ga('send', 'pageview');
</script>

  <h1><?php print "$dir" ?></h1>
<p>
<?php

// First: Assume this is a "year directory" and list all subdirectories.
$dir_count = 0;

$dir_read = "/home/2/s/superelectric/www" . $dir_request;
#print "<h1>$dir_read</h1>";
if ( is_dir( $dir_read )) {
    $files = scandir( $dir_read, SCANDIR_SORT_ASCENDING );
    foreach( $files as $file ) {
        if (($file != ".") && ($file != "..") && ($file != "index.php")) {
            print"<a href=\"$file/\">$file/</a><br/>\n";
            $dir_count += 1;
        } 
    }
}

if ($dir_count == 0) {
  // This was not a "year directory". Nothing to see.
  print "(Nothing to see here)\n";
}

// Print links to all years.
$year_start = 1998;
$year_current = date("Y");
print "\n\n<p>[\n";
for ($year = $year_start; $year < $year_current; $year += 1) {
  print "<a href=\"/$year/\">$year</a> |\n";
}
print "<a href=\"/$year_current\">$year_current</a>\n]</p>\n\n";


?>

</body>
</html>
