/*PGR-GNU*****************************************************************
File: vrp_vroomShipments.sql

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Ashish Kumar
Mail: ashishkr23438@gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

/*
signature start

.. code-block:: none

    vrp_vroomShipments(
      Shipments SQL, Shipments Time Windows SQL,
      Vehicles SQL, Breaks SQL, Breaks Time Windows SQL,
      Matrix SQL)  -- Experimental on v0.2

    RETURNS SET OF
    (seq, vehicle_seq, vehicle_id, step_seq, step_type, task_id,
     arrival, travel_time, service_time, waiting_time, load)

signature end

parameters start

============================== =========== =========================================================
Parameter                      Type        Description
============================== =========== =========================================================
**Shipments SQL**              ``TEXT``    `Shipments SQL`_ query describing pickup and delivery
                                           tasks that should happen within same route.
**Shipments Time Windows SQL** ``TEXT``    `Time Windows SQL`_ query describing valid slots
                                           for pickup and delivery service start.
**Vehicles SQL**               ``TEXT``    `Vehicles SQL`_ query describing the available vehicles.
**Breaks SQL**                 ``TEXT``    `Breaks SQL`_ query describing the driver breaks.
**Breaks Time Windows SQL**    ``TEXT``    `Time Windows SQL`_ query describing valid slots for
                                           break start.
**Matrix SQL**                 ``TEXT``    `Time Matrix SQL`_ query containing the distance or
                                           travel times between the locations.
============================== =========== =========================================================

parameters end

*/

-- v0.2
CREATE FUNCTION vrp_vroomShipments(
    TEXT,  -- shipments_sql (required)
    TEXT,  -- shipments_time_windows_sql (required)
    TEXT,  -- vehicles_sql (required)
    TEXT,  -- breaks_sql (required)
    TEXT,  -- breaks_time_windows_sql (required)
    TEXT,  -- matrix_sql (required)

    OUT seq BIGINT,
    OUT vehicle_seq BIGINT,
    OUT vehicle_id BIGINT,
    OUT step_seq BIGINT,
    OUT step_type INTEGER,
    OUT task_id BIGINT,
    OUT arrival TIMESTAMP,
    OUT travel_time INTERVAL,
    OUT service_time INTERVAL,
    OUT waiting_time INTERVAL,
    OUT load BIGINT[])
RETURNS SETOF RECORD AS
$BODY$
    SELECT
      seq,
      vehicle_seq,
      vehicle_id,
      step_seq,
      step_type,
      task_id,
      (to_timestamp(arrival) at time zone 'UTC')::TIMESTAMP,
      make_interval(secs => travel_time),
      make_interval(secs => service_time),
      make_interval(secs => waiting_time),
      load
    FROM _vrp_vroom(NULL, NULL, _pgr_get_statement($1),
                    _pgr_get_statement($2), _pgr_get_statement($3),
                    _pgr_get_statement($4), _pgr_get_statement($5),
                    _pgr_get_statement($6), 2::SMALLINT, false);
$BODY$
LANGUAGE SQL VOLATILE;


-- COMMENTS

COMMENT ON FUNCTION vrp_vroomShipments(TEXT, TEXT, TEXT, TEXT, TEXT, TEXT)
IS 'vrp_vroomShipments
 - EXPERIMENTAL
 - Parameters:
   - Shipments SQL with columns:
       p_id, p_location_index [, p_service, p_time_windows],
       d_id, d_location_index [, d_service, d_time_windows] [, amount, skills, priority]
   - Shipments Time Windows SQL with columns:
       id, kind, tw_open, tw_close
   - Vehicles SQL with columns:
       id, start_index, end_index
       [, service, delivery, pickup, skills, priority, time_window, breaks_sql, steps_sql]
   - Breaks SQL with columns:
       id [, service]
   - Breaks Time Windows SQL with columns:
       id, tw_open, tw_close
   - Matrix SQL with columns:
       start_vid, end_vid, agg_cost
 - Documentation:
   - ${PROJECT_DOC_LINK}/vrp_vroomShipments.html
';
