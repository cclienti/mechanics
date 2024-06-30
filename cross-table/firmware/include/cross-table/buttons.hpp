// This file is part of the cross-table project
// (https://github.com/cclienti/mechanics)
// Copyright (c) 2023 Christophe Clienti
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

#pragma once

#include "cross-table/config.hpp"
#include "cross-table/switch.hpp"


struct Buttons
{
    Buttons() :
        x_minus(TableConfig::pin_btn_x_minus, true),
        x_plus(TableConfig::pin_btn_x_plus, true),
        y_minus(TableConfig::pin_btn_y_minus, true),
        y_plus(TableConfig::pin_btn_y_plus, true),
        reset(TableConfig::pin_btn_reset, true),
        ok(TableConfig::pin_btn_ok, true),
        menu(TableConfig::pin_btn_menu, true)
    {}

	Switch x_minus;
	Switch x_plus;
	Switch y_minus;
	Switch y_plus;
	Switch reset;
	Switch ok;
    Switch menu;
};
