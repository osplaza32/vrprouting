/*PGR-GNU*****************************************************************
File: vroom_break_t.h

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
/*! @file */

#ifndef INCLUDE_C_TYPES_VROOM_VROOM_BREAK_T_H_
#define INCLUDE_C_TYPES_VROOM_VROOM_BREAK_T_H_
#pragma once

#include "c_types/typedefs.h"

/** @brief Vehicle's break attributes

@note C/C++/postgreSQL connecting structure for input
name | description
:----- | :-------
id | Identifier of break
vehicle_id | Identifier of vehicle
service | Duration of break
*/
struct Vroom_break_t {
  Idx id; /** Identifier of break */
  Idx vehicle_id;  /** Identifier of vehicle */
  Duration service; /** Duration of break */
};


#endif  // INCLUDE_C_TYPES_VROOM_VROOM_BREAK_T_H_
