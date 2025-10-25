use Modern::Perl;
use Koha::Installer::Output qw(say_warning say_failure say_success say_info);

return {
    bug_number  => "41101",
    description => "Add staff_viewonly column to borrower_attribute_type table",
    up          => sub {
        my ($args) = @_;
        my ( $dbh, $out ) = @$args{qw(dbh out)};

        if ( !column_exists( 'borrower_attribute_types', 'staff_viewonly' ) ) {

            $dbh->do(
                q{
                    ALTER TABLE borrower_attribute_types
                    ADD COLUMN `staff_viewonly` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'defines if the attribute is view-only by staff in the staff interface'
                    AFTER `opac_mandatory`
                }
            );

            say $out "Added column 'borrower_attribute_types.staff_viewonly'";

            $dbh->do(
                q{
                UPDATE borrower_attribute_types
                SET staff_viewonly = 0;
            }
            );
            say $out "Update staff_viewonly to make all existing attributes editable by default";
        }
    },

};
