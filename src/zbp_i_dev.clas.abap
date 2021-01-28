"! <p class="shorttext synchronized" lang="en">Behavior Implementation for ZI_DEV</p>
CLASS zbp_i_dev DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_dev.
  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF co_dev_status,
        under_specification TYPE zde_dev_status VALUE 'Spec',
        spec_ready          TYPE zde_dev_status VALUE 'SpecReady',
        development         TYPE zde_dev_status VALUE 'Developmnt',
        test                TYPE zde_dev_status VALUE 'Test',
        correction          TYPE zde_dev_status VALUE 'Correction',
        done                TYPE zde_dev_status VALUE 'Done',
        rejected            TYPE zde_dev_status VALUE 'Rejected',
      END OF co_dev_status.
    CONSTANTS:
      BEGIN OF co_time_unit,
        booking     TYPE zde_unit VALUE 'H',"Hours
        development TYPE zde_unit VALUE '10 ',"Days
        statistics  TYPE zde_unit VALUE '10 ',"Days
      END OF co_time_unit.
ENDCLASS.

CLASS zbp_i_dev IMPLEMENTATION.
ENDCLASS.
