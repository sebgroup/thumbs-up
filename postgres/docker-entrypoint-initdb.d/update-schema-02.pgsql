
CREATE OR REPLACE VIEW thumb_count AS
    SELECT
        p.page_id,
        t.thumbs_up,
        t.thumbs_down,
        coalesce(t.thumbs_up, 0) - coalesce(t.thumbs_down, 0) AS thumbs_net
    FROM (
        SELECT
            count(*) FILTER (WHERE thumb_up = TRUE) AS thumbs_up,
            count(*) FILTER (WHERE thumb_up = FALSE) AS thumbs_down,
            page_id
        FROM thumbs
        GROUP BY page_id
    ) t JOIN page_ids p ON p.id = t.page_id;

CREATE OR REPLACE FUNCTION top_thumbs_up(_limit int)
    RETURNS TABLE (page_id TEXT, thumbs_up BIGINT, thumbs_down BIGINT) AS
$$
    SELECT
        page_id,
        thumbs_up,
        thumbs_down
    FROM thumb_count
    ORDER BY thumbs_up DESC
    LIMIT (_limit);
$$
LANGUAGE sql
STABLE;

CREATE OR REPLACE FUNCTION top_thumbs_down(_limit int)
    RETURNS TABLE (page_id TEXT, thumbs_up BIGINT, thumbs_down BIGINT) AS
$$
    SELECT
        page_id,
        thumbs_up,
        thumbs_down
    FROM thumb_count
    ORDER BY thumbs_down DESC
    LIMIT (_limit);
$$
LANGUAGE sql
STABLE;

CREATE OR REPLACE FUNCTION top_thumbs_net(_limit int)
    RETURNS TABLE (page_id TEXT, thumbs_up BIGINT, thumbs_down BIGINT) AS
$$
    SELECT
        page_id,
        thumbs_up,
        thumbs_down
    FROM thumb_count
    ORDER BY thumbs_net DESC
    LIMIT (_limit);
$$
LANGUAGE sql
STABLE;
