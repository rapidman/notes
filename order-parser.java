 @Test
    public void test() throws Exception {
        DateTime dateTime = DateTime.parse("2017-01-01 07:16:00", DATE_TIME_FORMATTER);
        InputStream resourceAsStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("test.json");
        String json = IOUtils.toString(resourceAsStream);
        JsonNode tree = helper.getObjectMapper().readTree(json);
        JsonNode orders = tree.findPath("orders");
        for (JsonNode order : orders) {
            boolean carSearching = false;
            String orderState = order.findPath("order_state").asText();
            if ("CAR_SEARCHING".equals(orderState) || "null".equals(orderState)) {
                carSearching = true;
            }
            DateTime time = getDateTime(order.findPath("create_time"));
            if (carSearching && time != null && time.isBefore(dateTime)) {
                System.out.println(order.findPath("order_id"));
            }
        }
    }

    private DateTime getDateTime(JsonNode jsonNode) {
        return new DateTime(jsonNode.asLong());
    }
