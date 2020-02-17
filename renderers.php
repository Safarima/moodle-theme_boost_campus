<?php

class theme_boost_campus_core_renderer extends core_renderer {

    /**
     * This renders the navbar.
     * Uses bootstrap compatible html.
     */
    public function navbar() {
        var_dump($this->page->navbar);
        //return $this->render_from_template('core/navbar', $this->page->navbar);
    }
}