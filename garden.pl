# Garden Program that takes in type, color and height
# Returns what Categories the garden is satisfied
# Author: Patrick Lam
# Below is the standard boilerplate for Perl
#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use List::Util qw(all);

# Sees which categories are satisfied
sub categorize_flower_garden {
    my @garden = @_;
    my %categories;

    $categories{1} = 1 if all_tulips(@garden);
    $categories{2} = 1 if all_yellow_colors(@garden);
    $categories{3} = 1 if similar_height(@garden);
    $categories{4} = 1 if all_short_flowers(@garden);
    $categories{5} = 1 if all_tall_flowers(@garden);
    $categories{6} = 1 if same_color(@garden);
    $categories{7} = 1 if valid_colors(@garden);

    return \%categories;
}

sub main {
    open(my $in, '<', 'garden.txt') or die "Yo messed up, Error opening input file: $!";
    my $num_flowers = <$in>;
    chomp($num_flowers);

    my @garden;

    for (1..$num_flowers) {
        my $type   = <$in>; chomp($type);
        my $color  = <$in>; chomp($color);
        my $height = <$in>; chomp($height);

        push @garden, {
            type   => $type,
            color  => $color,
            height => $height
        };
    }
    close($in);

    my $categories = categorize_flower_garden(@garden);
    print "Categories:\n";
    for my $category (sort keys %$categories) {
        print "  Category $category: ", $categories->{$category} ? "Yes" : "No", "\n";
    }
}


# Note on what the all function does :
#   The function takes everything in the list
#   and goes and returns if they are all same

# Category 1
# Returns true if all flowers are tulips
sub all_tulips {
    my @garden = @_;
    return all { $_->{type} eq 'tulip' } @garden;
}

# Category 2
# Returns true if all the flowers are yellow
sub all_yellow_colors {
    my @garden = @_;
    return all { $_->{color} eq 'yellow' } @garden;
}

# Category 3
# Returns true if all the heights are within 3 inches
sub similar_height {
    my @garden = @_;
    return 1 if @garden == 1;  # Special case for a single flower

    my ($min_height, $max_height) = ($garden[0]{height}, $garden[0]{height});

    for my $flower (@garden[1..$#garden]) {
        my $height = $flower->{height};
        $min_height = $height if $height < $min_height;
        $max_height = $height if $height > $max_height;
    }
    return $max_height - $min_height <= 3;
}

# Category 4
# Returns true if all the height is under 8 inches
sub all_short_flowers {
    my @garden = @_;
    return all { $_->{height} < 8 } @garden;
}

# Category 5
# Returns true if all of the height is above 28
sub all_tall_flowers {
    my @garden = @_;
    return all { $_->{height} > 28 } @garden;
}

# Category 6
# Returns true if all of the colors are the same
sub same_color {
    my @garden = @_;
    my $first_color = $garden[0]{color};
    return all { $_->{color} eq $first_color } @garden;
}

# Category 7
# Returns true if all the colors are purple, yellow, or white
sub valid_colors {
    my @garden = @_;
    my %valid_colors = ('purple' => 1, 'yellow' => 1, 'white' => 1);
    return all { $valid_colors{$_->{color}} } @garden;
}

main();
