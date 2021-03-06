use TokyoTyrant;
use strict;
use warnings;

# create the object
my $rdb = TokyoTyrant::RDB->new();

# connect to the server
if(!$rdb->open("localhost", 1978)){
    my $ecode = $rdb->ecode();
    printf STDERR ("open error: %s\n", $rdb->errmsg($ecode));
}

# store records
if(!$rdb->put("foo", "hop") ||
   !$rdb->put("bar", "step") ||
   !$rdb->put("baz", "jump")){
    my $ecode = $rdb->ecode();
    printf STDERR ("put error: %s\n", $rdb->errmsg($ecode));
}

# retrieve records
my $value = $rdb->get("foo");
if(defined($value)){
    printf("%s\n", $value);
} else {
    my $ecode = $rdb->ecode();
    printf STDERR ("get error: %s\n", $rdb->errmsg($ecode));
}

# traverse records
$rdb->iterinit();
while(defined(my $key = $rdb->iternext())){
    my $value = $rdb->get($key);
    if(defined($value)){
        printf("%s:%s\n", $key, $value);
    }
}

# close the connection
if(!$rdb->close()){
    my $ecode = $rdb->ecode();
    printf STDERR ("close error: %s\n", $rdb->errmsg($ecode));
}

# tying usage
my %hash;
if(!tie(%hash, "TokyoCabinet::RDB", "localhost", 1978)){
    printf STDERR ("tie error\n");
}
$hash{"quux"} = "touchdown";
printf("%s\n", $hash{"quux"});
while(my ($key, $value) = each(%hash)){
    printf("%s:%s\n", $key, $value);
}
untie(%hash);
